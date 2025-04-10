import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :halo_elixir_app, HaloElixirAppWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: HaloElixirApp.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

# FusionAuth configuration
config :ueberauth, Ueberauth.Strategy.Fusion.OAuth,
  client_id: System.get_env("FUSION_CLIENT_ID") || "your-client-id",
  client_secret: System.get_env("FUSION_CLIENT_SECRET") || "your-client-secret",
  fusion_url: System.get_env("FUSION_URL") || "http://localhost:9011",
  redirect_url: "https://halo-elixir-app.fly.dev/auth/fusion/callback"
