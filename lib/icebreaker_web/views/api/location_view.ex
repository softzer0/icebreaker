defmodule IcebreakerWeb.Api.LocationView do
  use IcebreakerWeb, :view

  # def render("index.json", %{locations: locations}) do
  #   %{data: render_many(locations, __MODULE__, "location.json")}
  # end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, __MODULE__, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{
      user_id: location.user_id,
      coords: location.coords
    }
  end
end
