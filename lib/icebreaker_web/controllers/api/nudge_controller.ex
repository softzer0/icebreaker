defmodule IcebreakerWeb.Api.NudgeController do
  use IcebreakerWeb, :controller

  alias Icebreaker.Accounts
  alias Icebreaker.Accounts.User
  alias Icebreaker.Accounts.Nudge

  import IcebreakerWeb.Controllers.Plug

  require Logger

  plug :if_range_exceeded

  def send_nudge(conn, %{"to" => to}) do
    with %User{} = user <- conn.assigns[:user],
         nil <- Accounts.get_nudge_by_user(user.id),
         {:ok, nudge} <- Accounts.send_nudge(user, to) do
      conn
      |> render("show.json", %{nudge: nudge})
    else
      %Nudge{not_delivered: -1} ->
        conn
        |> json(%{error: "Already responded to nudge"})
      %Nudge{} ->
        conn
        |> json(%{error: "Already nudging or being nudged"})
    end
  end
end
