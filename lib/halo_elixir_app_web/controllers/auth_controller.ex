defmodule HaloElixirAppWeb.AuthController do
  require Logger
  use HaloElixirAppWeb, :controller
  use HaloElixirAppWeb, :verified_routes
  plug Ueberauth

  alias HaloElixirApp.Accounts

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      username: auth.info.nickname || auth.info.first_name,
      provider: Atom.to_string(auth.provider),
      token: auth.credentials.token,
      fusion_auth_id: auth.uid
    }

    case find_or_create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  def callback(conn, _params) do
    IO.inspect(conn)
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: ~p"/")
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> Ueberauth.Strategy.Fusion.logout()
  end

  defp find_or_create_user(%{fusion_auth_id: fusion_auth_id} = params) when is_binary(fusion_auth_id) do
    case Accounts.get_user_by_fusion_auth_id(fusion_auth_id) do
      nil -> create_user(params)
      user -> {:ok, user}
    end
  end

  defp find_or_create_user(%{username: username} = params) do
    case Accounts.get_user_by_username(username) do
      nil -> create_user(params)
      user -> update_user_auth(user, params)
    end
  end

  defp create_user(params) do
    Accounts.create_user(params)
  end

  defp update_user_auth(user, params) do
    # Update user with new auth details if they've changed
    Accounts.update_user(user, params)
  end
end
