defmodule IcebreakerWeb.PageController do
  use IcebreakerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
