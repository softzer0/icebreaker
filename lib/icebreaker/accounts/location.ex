defmodule Icebreaker.Accounts.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :alt, :string
    field :lat, :string
    field :lon, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:lon, :lat, :alt])
    |> validate_required([:lon, :lat, :alt])
  end
end
