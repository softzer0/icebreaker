defmodule Icebreaker.Accounts.Nudge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nudges" do
    field :active, :boolean, default: false
    field :not_delivered, :integer, default: 0
    field :sent, :naive_datetime
    field :from, :id
    field :to, :id

    timestamps()
  end

  @doc false
  def changeset(nudge, attrs) do
    nudge
    |> cast(attrs, [:active, :not_delivered, :sent, :from, :to])
    |> unique_constraint([:from, :to])
  end
end
