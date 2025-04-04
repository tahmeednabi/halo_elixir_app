defmodule HaloElixirApp.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HaloElixirApp.Chat` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        code: "some code"
      })
      |> HaloElixirApp.Chat.create_room()

    room
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        user_name: "some user_name"
      })
      |> HaloElixirApp.Chat.create_message()

    message
  end

  @doc """
  Generate a room_user.
  """
  def room_user_fixture(attrs \\ %{}) do
    {:ok, room_user} =
      attrs
      |> Enum.into(%{
        user_name: "some user_name"
      })
      |> HaloElixirApp.Chat.create_room_user()

    room_user
  end
end
