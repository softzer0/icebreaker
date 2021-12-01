defmodule IcebreakerWeb.Api.NudgeView do
  use IcebreakerWeb, :view

  def render("show.json", %{nudge: nudge}) do
    %{data: render_one(nudge, __MODULE__, "nudge.json")}
  end

  def render("nudge.json", %{nudge: nudge}) do
    %{
      to: nudge.to,
      not_delivered: nudge.not_delivered,
      active: nudge.active,
      sent: nudge.sent
    }
  end
end
