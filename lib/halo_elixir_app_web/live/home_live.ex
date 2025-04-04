defmodule HaloElixirAppWeb.HomeLive do
  use HaloElixirAppWeb, :live_view

  alias HaloElixirApp.Chat

  @impl true
  def mount(_params, session, socket) do
    current_user =
      case session["user_id"] do
        nil -> nil
        user_id -> HaloElixirApp.Accounts.get_user(user_id)
      end

    {:ok, assign(socket,
      page_title: "Chat App",
      join_error: nil,
      current_user: current_user,
      room_code: ""
    )}
  end

  @impl true
  def handle_event("create_room", _params, socket) do
    if socket.assigns.current_user != nil do
      case Chat.create_room_with_random_code() do
        {:ok, room} ->
          {:noreply,
           socket
           |> put_flash(:info, "Room created successfully!")
           |> push_navigate(to: ~p"/room/#{room.code}")}

        {:error, _reason} ->
          {:noreply,
           socket
           |> put_flash(:error, "Failed to create room. Please try again.")
           |> assign(join_error: "Failed to create room")}
      end
    else
      {:noreply, assign(socket, join_error: "Please login to create a room")}
    end
  end

  @impl true
  @spec handle_event(<<_::72, _::_*72>>, map(), any()) :: {:noreply, any()}
  def handle_event("validate_room_code", %{"code" => code}, socket) do
    {:noreply, assign(socket, room_code: code)}
  end

  @impl true
  def handle_event("join_room", %{"code" => code}, socket) do
    if socket.assigns.current_user do
      code = String.upcase(code)

      case Chat.get_room_by_code(code) do
        %Chat.Room{} = _room ->
          {:noreply,
           socket
           |> push_navigate(to: ~p"/room/#{code}")}

        nil ->
          {:noreply, assign(socket, join_error: "Room not found")}
      end
    else
      {:noreply, assign(socket, join_error: "Please login to join a room")}
    end
  end
end
