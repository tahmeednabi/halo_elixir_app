defmodule HaloElixirAppWeb.AuthController do
  require Logger
  use HaloElixirAppWeb, :controller
  use HaloElixirAppWeb, :verified_routes
  plug Ueberauth

  alias HaloElixirApp.Accounts

  # def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
  #   user_params = %{
  #     username: auth.info.nickname || auth.info.first_name,
  #     provider: Atom.to_string(auth.provider),
  #     token: auth.credentials.token,
  #     fusion_auth_id: auth.uid
  #   }

  #   case find_or_create_user(user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "Successfully authenticated.")
  #       |> put_session(:user_id, user.id)
  #       |> configure_session(renew: true)
  #       |> redirect(to: ~p"/")

  #     {:error, _reason} ->
  #       conn
  #       |> put_flash(:error, "Error signing in")
  #       |> redirect(to: ~p"/")
  #   end
  # end

  # Add this function to log the auth struct
  defp log_auth_details(auth) do
    # Log basic auth info
    Logger.info("Auth provider: #{inspect(auth.provider)}")
    Logger.info("Auth uid: #{inspect(auth.uid)}")

    # Log credentials (token) safely
    if auth.credentials do
      # Only log first few characters of tokens for security
      token_preview = if auth.credentials.token,
        do: String.slice(auth.credentials.token, 0..10) <> "...",
        else: "nil"

      refresh_token_preview = if auth.credentials.refresh_token,
        do: String.slice(auth.credentials.refresh_token, 0..5) <> "...",
        else: "nil"

      Logger.info("Auth token preview: #{token_preview}")
      Logger.info("Auth refresh token: #{refresh_token_preview}")
      Logger.info("Auth token type: #{inspect(auth.credentials.token_type)}")
      Logger.info("Auth expires: #{inspect(auth.credentials.expires)}")
      Logger.info("Auth expires_at: #{inspect(auth.credentials.expires_at)}")
    else
      Logger.info("Auth credentials: nil")
    end

    # Log user info
    if auth.info do
      Logger.info("Auth info name: #{inspect(auth.info.name)}")
      Logger.info("Auth info nickname: #{inspect(auth.info.nickname)}")
      Logger.info("Auth info first_name: #{inspect(auth.info.first_name)}")
      Logger.info("Auth info email: #{inspect(auth.info.email)}")
    else
      Logger.info("Auth info: nil")
    end

    # Log extra info
    Logger.info("Auth extra: #{inspect(auth.extra)}")
  end

  # Add this function to log failure details
  defp log_failure_details(failure) do
    Logger.error("Auth failure provider: #{inspect(failure.provider)}")
    Logger.error("Auth failure strategy: #{inspect(failure.strategy)}")

    if failure.errors && length(failure.errors) > 0 do
      Enum.each(failure.errors, fn error ->
        Logger.error("Auth failure error: #{inspect(error.message_key)} - #{inspect(error.message)}")
      end)
    else
      Logger.error("Auth failure with no specific errors")
    end
  end

  # Modify your callback function to include logging
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Logger.info("Authentication successful, processing auth data")
    log_auth_details(auth)

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

      {:error, reason} ->
        Logger.error("Error creating/finding user: #{inspect(reason)}")
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: ~p"/")
    end
  end

  # Modify your failure callback to include logging
  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    Logger.error("Authentication failed")
    log_failure_details(failure)

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: ~p"/")
  end

  # Add a fallback callback for unexpected cases
  def callback(conn, params) do
    Logger.error("Unexpected callback state. Params: #{inspect(params)}")
    Logger.error("Conn assigns: #{inspect(conn.assigns)}")

    conn
    |> put_flash(:error, "Unexpected authentication error.")
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
