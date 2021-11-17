defmodule Icebreaker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone, :string
      add :name, :string
      add :birthdate, :naive_datetime
      add :verify_token, :string
      add :activated, :boolean, default: false
      add :face_id, :string, size: 36
      add :last_selfie_id, :string, size: 36

      timestamps()
    end

    create unique_index(:users, [:phone])
  end
end
