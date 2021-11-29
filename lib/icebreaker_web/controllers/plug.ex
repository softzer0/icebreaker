defmodule IcebreakerWeb.Controllers.Plug do
  import Plug.Conn
  import Phoenix.Controller

  alias Icebreaker.Accounts.User

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
end
