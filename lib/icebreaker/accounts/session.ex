defmodule Icebreaker.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :token, :string
    belongs_to :user, Icebreaker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token])
  end
end
