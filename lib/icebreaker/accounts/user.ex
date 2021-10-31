defmodule Icebreaker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :birthdate, :naive_datetime
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :name, :birthdate])
    |> validate_required([:phone, :name, :birthdate])
    |> unique_constraint(:phone)
  end
end
