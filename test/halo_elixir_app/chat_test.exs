defmodule HaloElixirApp.ChatTest do
  use HaloElixirApp.DataCase

  alias HaloElixirApp.Chat

  describe "rooms" do
    alias HaloElixirApp.Chat.Room

    import HaloElixirApp.ChatFixtures

    @invalid_attrs %{code: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Chat.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Chat.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{code: "some code"}

      assert {:ok, %Room{} = room} = Chat.create_room(valid_attrs)
      assert room.code == "some code"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{code: "some updated code"}

      assert {:ok, %Room{} = room} = Chat.update_room(room, update_attrs)
      assert room.code == "some updated code"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_room(room, @invalid_attrs)
      assert room == Chat.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Chat.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Chat.change_room(room)
    end
  end

  describe "messages" do
    alias HaloElixirApp.Chat.Message

    import HaloElixirApp.ChatFixtures

    @invalid_attrs %{content: nil, user_name: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: "some content", user_name: "some user_name"}

      assert {:ok, %Message{} = message} = Chat.create_message(valid_attrs)
      assert message.content == "some content"
      assert message.user_name == "some user_name"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: "some updated content", user_name: "some updated user_name"}

      assert {:ok, %Message{} = message} = Chat.update_message(message, update_attrs)
      assert message.content == "some updated content"
      assert message.user_name == "some updated user_name"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end

  describe "room_users" do
    alias HaloElixirApp.Chat.RoomUser

    import HaloElixirApp.ChatFixtures

    @invalid_attrs %{user_name: nil}

    test "list_room_users/0 returns all room_users" do
      room_user = room_user_fixture()
      assert Chat.list_room_users() == [room_user]
    end

    test "get_room_user!/1 returns the room_user with given id" do
      room_user = room_user_fixture()
      assert Chat.get_room_user!(room_user.id) == room_user
    end

    test "create_room_user/1 with valid data creates a room_user" do
      valid_attrs = %{user_name: "some user_name"}

      assert {:ok, %RoomUser{} = room_user} = Chat.create_room_user(valid_attrs)
      assert room_user.user_name == "some user_name"
    end

    test "create_room_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_room_user(@invalid_attrs)
    end

    test "update_room_user/2 with valid data updates the room_user" do
      room_user = room_user_fixture()
      update_attrs = %{user_name: "some updated user_name"}

      assert {:ok, %RoomUser{} = room_user} = Chat.update_room_user(room_user, update_attrs)
      assert room_user.user_name == "some updated user_name"
    end

    test "update_room_user/2 with invalid data returns error changeset" do
      room_user = room_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_room_user(room_user, @invalid_attrs)
      assert room_user == Chat.get_room_user!(room_user.id)
    end

    test "delete_room_user/1 deletes the room_user" do
      room_user = room_user_fixture()
      assert {:ok, %RoomUser{}} = Chat.delete_room_user(room_user)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_room_user!(room_user.id) end
    end

    test "change_room_user/1 returns a room_user changeset" do
      room_user = room_user_fixture()
      assert %Ecto.Changeset{} = Chat.change_room_user(room_user)
    end
  end
end
