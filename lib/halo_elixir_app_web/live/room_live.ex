defmodule HaloElixirAppWeb.RoomLive do
  use HaloElixirAppWeb, :live_view

  alias HaloElixirApp.Chat
  alias HaloElixirApp.Chat.Room
  alias Phoenix.PubSub

  @impl true
  def mount(%{"code" => code} = params, session, socket) do
    current_user =
      case session["user_id"] do
        nil -> nil
        user_id -> HaloElixirApp.Accounts.get_user(user_id)
      end

    socket = assign(socket, current_user: current_user)

    username = socket.assigns.current_user.username
    socket = assign(socket, username: username)

    if connected?(socket) and username do
      case Chat.get_room_by_code(code) do
        %Room{} = room ->
          PubSub.subscribe(HaloElixirApp.PubSub, "room:#{room.id}")

          {:ok, room_user} =
            Chat.create_room_user(%{room_id: room.id, user_name: username})

          PubSub.broadcast(
            HaloElixirApp.PubSub,
            "room:#{room.id}",
            {:user_joined, room_user}
          )

          # Set up process cleanup on disconnect
          Process.flag(:trap_exit, true)

          messages = Chat.list_messages_for_room(room)
          users = Chat.list_users_in_room(room)

          {:ok,
           socket
           |> stream_configure(:messages, dom_id: &"message-#{&1.id}")
           |> stream(:messages, messages)
           |> stream(:users, users)
           |> assign(:room, room)
           |> assign(:room_user, room_user)
           |> assign(:username, username)
           |> assign(:message_text, "")
           |> assign(:page_title, "Chat Room: #{room.code}")}

        nil ->
          {:ok,
           socket
           |> put_flash(:error, "Room not found")
           |> push_navigate(to: ~p"/")}
      end
    else
      {:ok,
       socket
       |> put_flash(:error, "Login to join a room")
       |> push_navigate(to: ~p"/")}
    end
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, :live_action_params, params)}
  end

  @impl true
  def handle_event("send_message", %{"message" => message_text}, socket) do
    if String.trim(message_text) != "" do
      room = socket.assigns.room
      username = socket.assigns.current_user.username

      {:ok, message} =
        Chat.create_message(%{
          content: message_text,
          room_id: room.id,
          user_name: username
        })

      PubSub.broadcast(
        HaloElixirApp.PubSub,
        "room:#{room.id}",
        {:new_message, message}
      )

      {:noreply, assign(socket, :message_text, "")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("form_change", %{"message" => message_text}, socket) do
    {:noreply, assign(socket, :message_text, message_text)}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  @impl true
  def handle_info({:user_joined, room_user}, socket) do
    {:noreply, stream_insert(socket, :users, room_user)}
  end

  @impl true
  def handle_info({:user_left, user_id}, socket) do
    {:noreply, stream_delete(socket, :users, %{id: user_id})}
  end

  @impl true
  def terminate(_reason, socket) do
    if room_user = socket.assigns[:room_user] do
      room = socket.assigns.room
      Chat.delete_room_user(room_user)

      PubSub.broadcast(
        HaloElixirApp.PubSub,
        "room:#{room.id}",
        {:user_left, room_user.id}
      )
    end

    :ok
  end
end
