defmodule IcebreakerWeb.Api.UserController do
  use IcebreakerWeb, :controller
  alias Icebreaker.Accounts
  alias Icebreaker.Base.{Sms, Token}

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
         {:ok, message} <- Sms.send_token(phone, token),
         {:ok, user} <- Accounts.update_user(user, %{verify_token: token}) do
      Logger.info(user)
      Logger.info(message)

      conn
      |> json(%{user: user})
    end
  end

  def verify_token(conn, %{"token" => token}) do
    conn
    |> json(%{token: token})
  end
end
