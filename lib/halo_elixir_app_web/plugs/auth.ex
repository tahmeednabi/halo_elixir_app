defmodule HaloElixirAppWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  use HaloElixirAppWeb, :verified_routes

  alias HaloElixirApp.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      _user = conn.assigns[:current_user] ->
        conn

      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
