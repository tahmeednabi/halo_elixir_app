defmodule HaloElixirApp.Repo.Migrations.ModifyTokenFieldInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :token, :text
    end
  end
end
