defmodule Icebreaker.Accounts.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    belongs_to :user, Icebreaker.Accounts.User
    field :init_coords, Geo.PostGIS.Geometry
    field :coords, Geo.PostGIS.Geometry

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:init_coords, :coords, :user_id])
  end
end
