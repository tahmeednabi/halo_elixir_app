defmodule HaloElixirApp.Repo do
  use Ecto.Repo,
    otp_app: :halo_elixir_app,
    adapter: Ecto.Adapters.Postgres
end
