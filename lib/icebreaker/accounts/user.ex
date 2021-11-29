defmodule Icebreaker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:birthdate, :name, :phone, :activated, :exceeded_range]}
  schema "users" do
    field :name, :string
    field :phone, :string
    field :verify_token, :string
    field :birthdate, :date
    field :activated, :boolean, default: false
    field :face_id, :string
    field :last_selfie_id, :string
    field :exceeded_range, :boolean, default: false
    has_many :sessions, Icebreaker.Accounts.Session
    has_one :location, Icebreaker.Accounts.Location

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :name, :birthdate, :verify_token, :activated, :face_id, :last_selfie_id, :exceeded_range])
    |> validate_required([:phone])
    |> unique_constraint(:phone)
  end
end
