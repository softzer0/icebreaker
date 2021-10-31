defmodule Icebreaker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :name, :string
      add :birthdate, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:phone])
  end
end
