defmodule Icebreaker.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    execute("CREATE EXTENSION IF NOT EXISTS postgis;")
    execute("SELECT AddGeometryColumn ('locations','init_coords',4326,'POINT',2);")
    execute("SELECT AddGeometryColumn ('locations','coords',4326,'POINT',2);")

    # Once a GIS data table exceeds a few thousand rows, you will want to build an index to speed up spatial searches of the data
    # Syntax - CREATE INDEX [indexname] ON [tablename] USING GIST ( [geometryfield] );
    execute("CREATE INDEX locations_init_coords_idx ON locations USING GIST (init_coords);")
    execute("CREATE INDEX locations_coords_idx ON locations USING GIST (coords);")

    create index(:locations, [:user_id])
  end
end
