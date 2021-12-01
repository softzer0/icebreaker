defmodule Icebreaker.Repo.Migrations.CreateNudges do
  use Ecto.Migration

  def change do
    create table(:nudges) do
      add :active, :boolean, default: nil, null: true
      add :not_delivered, :integer, default: 0
      add :sent, :naive_datetime
      add :from, references(:users, on_delete: :delete_all)
      add :to, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:nudges, [:from])
    create index(:nudges, [:to])
    execute("ALTER TABLE nudges ADD CONSTRAINT nudges_from_to_key UNIQUE ('from', 'to');")
  end
end
