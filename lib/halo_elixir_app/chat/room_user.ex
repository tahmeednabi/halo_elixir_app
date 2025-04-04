defmodule HaloElixirApp.Chat.RoomUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_users" do
    field :user_name, :string

    belongs_to :room, HaloElixirApp.Chat.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room_user, attrs) do
    room_user
    |> cast(attrs, [:user_name, :room_id])
    |> validate_required([:user_name, :room_id])
    |> foreign_key_constraint(:room_id)
    |> unique_constraint([:user_name, :room_id])
  end
end
