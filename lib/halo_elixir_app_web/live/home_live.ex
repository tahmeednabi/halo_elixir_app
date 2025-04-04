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
      username: "",
      current_user: current_user
    )}
  end

  @impl true
  def handle_event("create_room", %{"username" => username}, socket) do
    if valid_username?(username) do
      case Chat.create_room_with_random_code() do
        {:ok, room} ->
          {:noreply,
           socket
           |> put_flash(:info, "Room created successfully!")
           |> push_navigate(to: ~p"/room/#{room.code}?username=#{username}")}

        {:error, _reason} ->
          {:noreply,
           socket
           |> put_flash(:error, "Failed to create room. Please try again.")
           |> assign(join_error: "Failed to create room")}
      end
    else
      {:noreply, assign(socket, join_error: "Please enter a username")}
    end
  end

  @impl true
  def handle_event("join_room", %{"code" => code, "username" => username}, socket) do
    if valid_username?(username) do
      code = String.upcase(code)

      case Chat.get_room_by_code(code) do
        %Chat.Room{} = _room ->
          {:noreply,
           socket
           |> push_navigate(to: ~p"/room/#{code}?username=#{username}")}

        nil ->
          {:noreply, assign(socket, join_error: "Room not found")}
      end
    else
      {:noreply, assign(socket, join_error: "Please enter a username")}
    end
  end

  @impl true
  def handle_event("validate_username", %{"value" => username}, socket) do
    {:noreply, assign(socket, username: username)}
  end

  @impl true
  def handle_event("validate_username", %{"key" => _key, "value" => username}, socket) do
    {:noreply, assign(socket, username: username)}
  end

  defp valid_username?(username) do
    username && String.trim(username) != ""
  end
end
