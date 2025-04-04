defmodule HaloElixirApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias HaloElixirApp.Repo
  alias HaloElixirApp.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by username.
  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a user by FusionAuth ID.
  """
  def get_user_by_fusion_auth_id(fusion_auth_id) do
    Repo.get_by(User, fusion_auth_id: fusion_auth_id)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Authenticates a user by username and password.
  """
  def authenticate_user(username, password) do
    user = get_user_by_username(username)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end
end
