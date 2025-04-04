defmodule HaloElixirApp.Repo.Migrations.CreateRoomUsers do
  use Ecto.Migration

  def change do
    create table(:room_users) do
      add :user_name, :string
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:room_users, [:room_id])
  end
end
