defmodule IcebreakerWeb.Api.UserController do
  use IcebreakerWeb, :controller
  alias Icebreaker.Accounts

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
end
