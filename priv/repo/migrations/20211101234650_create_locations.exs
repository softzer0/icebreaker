defmodule Icebreaker.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :lon, :string
      add :lat, :string
      add :alt, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:locations, [:user_id])
  end
end
