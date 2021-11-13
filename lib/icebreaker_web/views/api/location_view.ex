defmodule IcebreakerWeb.Api.LocationView do
  use IcebreakerWeb, :view
  alias IcebreakerWeb.LocationView

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{
      id: location.id,
      coods: location.coords
    }
  end
end
