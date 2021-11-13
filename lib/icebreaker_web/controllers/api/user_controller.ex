defmodule IcebreakerWeb.Api.UserController do
  use IcebreakerWeb, :controller
  alias Icebreaker.Accounts
  alias Icebreaker.Base.{Sms, Token, Guardian}
  alias Accounts.User

  require Logger

  action_fallback IcebreakerWeb.FallbackController

  @doc """
  Used when user signs up for the very first time
  """
  def init_verify(conn, %{"phone" => phone}) do
    with token <- Token.generate(),
         {:ok, user} <- Accounts.create_user(%{phone: phone}),
         {:ok, _message} <- Sms.send_token(phone, token),
         {:ok, user} <- Accounts.update_user(user, %{verify_token: token}) do
      conn
      |> json(%{user: user})
    end
  end

  def verify_token(conn, %{"phone" => phone, "token" => token}) do
    with %User{} = user <- Accounts.get_user_by_phone(phone),
         true <- not user.activated and user.verify_token === token,
         {:ok, user} <- Accounts.update_user(user, %{activated: true, verify_token: nil}),
         conn <- Guardian.Plug.sign_in(conn, user),
         {:ok, jwt_access, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :hour}),
         {:ok, jwt_refresh, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {90, :days}) do
      # TODO: Save refresh token in sessions for the user
      conn
      |> json(%{token: jwt_access, refresh: jwt_refresh})
    else
      nil ->
        conn |> json(%{error: "User not found"})

      false ->
        conn |> json(%{error: "Token doesn't match or already verified"})

      {:error, reason} ->
        conn
        |> json(error: reason)
    end
  end

  def change_user_data(conn, %{"name" => name, "birthdate" => birthdate}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         {:ok, user} <- Accounts.update_user(user, %{name: name, birthdate: birthdate}) do
      conn
      |> render("show.json", %{user: user})
    end
  end
end
