defmodule IcebreakerWeb.Api.UserController do
  use IcebreakerWeb, :controller

  alias Icebreaker.Accounts
  alias Icebreaker.Base.{Sms, Token, Guardian, Rekognition}
  alias Accounts.User

  import IcebreakerWeb.Controllers.Plug

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
      |> render("show.json", %{user: user})
    end
  end

  def verify_token(conn, %{"phone" => phone, "token" => token}) do
    with %User{} = user <- Accounts.get_user_by_phone(phone),
         true <- not user.activated and user.verify_token === token,
         {:ok, user} <- Accounts.update_user(user, %{activated: true, verify_token: nil}),
         conn <- Guardian.Plug.sign_in(conn, user),
         {:ok, jwt_access, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access"),
         {:ok, jwt_refresh, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "refresh") do
      Accounts.save_session(user, jwt_refresh)

      conn
      |> json(%{token: jwt_access, refresh: jwt_refresh})
    else
      nil ->
        conn |> json(%{error: "User not found"})

      false ->
        conn |> json(%{error: "Token doesn't match or already verified"})

      {:error, reason} ->
        conn
        |> json(%{error: reason})
    end
  end

  def refresh_token(conn, %{"refresh" => refresh}) do
    with {:ok, _old_stuff, {access, _new_claims}} <- Guardian.exchange(refresh, "refresh", "access") do
      conn
      |> json(%{token: access})
    else
      {:error, _} ->
        conn
        |> json(%{error: "Invalid token provided"})
    end
  end

  plug :if_range_exceeded when action in [:change_user_data]

  def change_user_data(conn, %{"name" => name, "birthdate" => birthdate} = data) do
    with %User{} = user <- conn.assigns[:user],
         {:ok, user} <- Accounts.update_user(user, %{name: name, birthdate: birthdate}),
         {:ok, user} <- change_selfie(user, Map.get(data, "selfie")) do
      conn
      |> render("show.json", %{user: user})
    else
      _ ->
        conn
        |> json(%{error: "Invalid data provided"})
    end
  end

  defp change_selfie(%User{} = user, nil), do: {:ok, user}

  defp change_selfie(%User{} = user, b64_selfie) do
    selfie_binary_data = Base.decode64!(b64_selfie)
    Rekognition.search_or_index_face(user, selfie_binary_data)
  end
end
