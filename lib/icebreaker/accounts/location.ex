defmodule Icebreaker.Accounts.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    belongs_to :user, Icebreaker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:coords, :user_id])
  end
end
