defmodule HaloElixirApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :password_hash, :string
      add :provider, :string
      add :token, :string
      add :fusion_auth_id, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
    create index(:users, [:fusion_auth_id])
  end
end
