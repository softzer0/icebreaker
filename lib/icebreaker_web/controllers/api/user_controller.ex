defmodule IcebreakerWeb.Api.UserController do
  use IcebreakerWeb, :controller
  alias Icebreaker.Accounts
  alias Icebreaker.Base.{Sms, Token}
  alias Accounts.User

  require Logger

  action_fallback IcebreakerWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> render("show.json", user)

      {:error, _} ->
        conn
    end
  end

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
         true <- match_token?(user.verify_token, token),
         {:ok, user} <- Accounts.update_user(user, %{activated: true}) do
          # TODO: Sign in user if everything is okay
      conn
      |> json(%{user: user})
    end
  end

  def login(conn, _params) do

    conn
    |> json("Ok")
  end

  # * Private helpers

  defp match_token?(user_token, token), do: user_token == token
end
