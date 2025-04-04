defmodule HaloElixirApp.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias HaloElixirApp.Repo

  alias HaloElixirApp.Chat.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Gets a single room by its code.
  Returns nil if no room exists with the given code.

  ## Examples

      iex> get_room_by_code("ABCD")
      %Room{}

      iex> get_room_by_code("WXYZ")
      nil

  """
  def get_room_by_code(code) when is_binary(code) do
    Repo.get_by(Room, code: code)
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a room with a random 4-letter code.
  Will retry up to 10 times if the generated code is already taken.

  ## Examples

      iex> create_room_with_random_code()
      {:ok, %Room{}}

      iex> create_room_with_random_code()
      {:error, %Ecto.Changeset{}}

  """
  def create_room_with_random_code(retries \\ 10)

  def create_room_with_random_code(0), do: {:error, :too_many_retries}

  def create_room_with_random_code(retries) do
    code = Room.generate_code()

    case create_room(%{code: code}) do
      {:ok, room} ->
        {:ok, room}

      {:error, %Ecto.Changeset{errors: [code: {"has already been taken", _}]}} ->
        create_room_with_random_code(retries - 1)

      error ->
        error
    end
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  alias HaloElixirApp.Chat.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Returns the list of messages for a specific room.
  Messages are ordered by insertion time (oldest first).

  ## Examples

      iex> list_messages_for_room(room)
      [%Message{}, ...]

  """
  def list_messages_for_room(%Room{} = room) do
    Message
    |> where([m], m.room_id == ^room.id)
    |> order_by([m], asc: m.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  alias HaloElixirApp.Chat.RoomUser

  @doc """
  Returns the list of room_users.

  ## Examples

      iex> list_room_users()
      [%RoomUser{}, ...]

  """
  def list_room_users do
    Repo.all(RoomUser)
  end

  @doc """
  Returns the list of users in a specific room.

  ## Examples

      iex> list_users_in_room(room)
      [%RoomUser{}, ...]

  """
  def list_users_in_room(%Room{} = room) do
    RoomUser
    |> where([ru], ru.room_id == ^room.id)
    |> Repo.all()
  end

  @doc """
  Gets a single room_user.

  Raises `Ecto.NoResultsError` if the Room user does not exist.

  ## Examples

      iex> get_room_user!(123)
      %RoomUser{}

      iex> get_room_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room_user!(id), do: Repo.get!(RoomUser, id)

  @doc """
  Creates a room_user.

  ## Examples

      iex> create_room_user(%{field: value})
      {:ok, %RoomUser{}}

      iex> create_room_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room_user(attrs \\ %{}) do
    %RoomUser{}
    |> RoomUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room_user.

  ## Examples

      iex> update_room_user(room_user, %{field: new_value})
      {:ok, %RoomUser{}}

      iex> update_room_user(room_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room_user(%RoomUser{} = room_user, attrs) do
    room_user
    |> RoomUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room_user.

  ## Examples

      iex> delete_room_user(room_user)
      {:ok, %RoomUser{}}

      iex> delete_room_user(room_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room_user(%RoomUser{} = room_user) do
    Repo.delete(room_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room_user changes.

  ## Examples

      iex> change_room_user(room_user)
      %Ecto.Changeset{data: %RoomUser{}}

  """
  def change_room_user(%RoomUser{} = room_user, attrs \\ %{}) do
    RoomUser.changeset(room_user, attrs)
  end
end
