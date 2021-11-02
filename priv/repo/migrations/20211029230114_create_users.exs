defmodule Icebreaker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :name, :string
      add :birthdate, :naive_datetime
      add :verify_token, :string
      add :activated, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:phone])
  end
end
