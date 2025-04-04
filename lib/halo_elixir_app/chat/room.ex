defmodule HaloElixirApp.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :string

    has_many :messages, HaloElixirApp.Chat.Message
    has_many :room_users, HaloElixirApp.Chat.RoomUser

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:code])
    |> validate_required([:code])
    |> validate_length(:code, is: 4)
    |> validate_format(:code, ~r/^[A-Z0-9]{4}$/,
      message: "must be 4 uppercase letters or numbers"
    )
    |> unique_constraint(:code)
  end

  @doc """
  Generates a random 4-letter uppercase alphanumeric code
  """
  def generate_code do
    allowed_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for _ <- 1..4, into: "", do: <<Enum.random(String.to_charlist(allowed_chars))>>
  end
end
