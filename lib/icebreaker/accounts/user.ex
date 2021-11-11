defmodule Icebreaker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:birthdate, :name, :phone, :activated]}
  schema "users" do
    field :name, :string
    field :phone, :string
    field :verify_token, :string
    field :birthdate, :naive_datetime
    field :activated, :boolean, default: false
    has_many :sessions, Icebreaker.Accounts.Session
    has_one :location, Icebreaker.Accounts.Location

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :name, :birthdate, :verify_token, :activated])
    |> validate_required([:phone])
    |> unique_constraint(:phone)
  end
end
