defmodule IcebreakerWeb.Controllers.Plug do
  import Plug.Conn
  import Phoenix.Controller

  alias Icebreaker.Accounts.Nudge
  alias Icebreaker.Accounts.User
  alias Icebreaker.Accounts

  def if_range_exceeded(conn, _) do
    with %User{} = user <- Guardian.Plug.current_resource(conn) do
      case user do
        %{exceeded_range: true} ->
          conn
          |> json(%{error: "Range exceeded, please update selfie"}) |> halt()
        _ ->
          assign(conn, :user, user)
      end
    end
  end

  def if_being_nudged(conn, _) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %Nudge{} = nudge <- Accounts.get_nudge_by_user(user.id) do
      assign(conn, :nudge, nudge)
    else
      _ ->
        conn
    end
  end
end
