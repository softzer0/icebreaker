defmodule IcebreakerWeb.Api.UserView do
  use IcebreakerWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      name: user.name,
      birthdate: user.birthdate,
      phone: user.phone
    }
  end
end
