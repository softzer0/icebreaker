defmodule IcebreakerWeb.Api.LocationController do
  use IcebreakerWeb, :controller

  alias Icebreaker.Accounts
  alias Icebreaker.Accounts.Location
  alias Accounts.User

  import IcebreakerWeb.Controllers.Plug

  action_fallback IcebreakerWeb.FallbackController

  # def index(conn, _params) do
  #   locations = Accounts.list_locations()
  #   render(conn, "index.json", locations: locations)
  # end

  def create(conn, %{"location" => location_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         {:ok, %Location{} = location} <- Accounts.create_location(user, location_params) do
      conn
      |> put_status(:created)
      |> render("show.json", location: location)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   location = Accounts.get_location!(id)
  #   render(conn, "show.json", location: location)
  # end

  defp show_users_in_vicinity(conn, %User{} = user) do
    results = Accounts.list_users_in_vicinity(user.id)
    conn
    |> json(results)
  end

  plug :if_range_exceeded when action in [:update]

  def update(conn, %{"location" => location_params}) do
    with %User{} = user <- conn.assigns[:user],
         location <- Accounts.get_location_by_user!(user.id) do
      case Accounts.update_location(location, location_params, user) do
        {:ok, _, false} ->
          show_users_in_vicinity(conn, user)
        _ ->
          conn
          |> json(%{error: "User has went out of range, please update selfie"})
      end
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   location = Accounts.get_location!(id)

  #   with {:ok, %Location{}} <- Accounts.delete_location(location) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
