defmodule HaloElixirApp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
