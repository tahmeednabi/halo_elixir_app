defmodule HaloElixirApp.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :user_name, :string

    belongs_to :room, HaloElixirApp.Chat.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_name, :room_id])
    |> validate_required([:content, :user_name, :room_id])
    |> foreign_key_constraint(:room_id)
  end
end
