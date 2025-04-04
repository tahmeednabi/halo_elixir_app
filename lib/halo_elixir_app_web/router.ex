defmodule HaloElixirAppWeb.Router do
  use HaloElixirAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HaloElixirAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HaloElixirAppWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :browser
    plug HaloElixirAppWeb.Plugs.Auth
    plug :authenticate_user
  end

  scope "/", HaloElixirAppWeb do
    pipe_through :browser

    live "/", HomeLive
    get "/logout", AuthController, :logout
  end

  scope "/auth", HaloElixirAppWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/room", HaloElixirAppWeb do
    pipe_through :auth

    live "/:code", RoomLive
  end

  defp authenticate_user(conn, _) do
    HaloElixirAppWeb.Plugs.Auth.authenticate_user(conn, [])
  end

  # Other scopes may use custom stacks.
  # scope "/api", HaloElixirAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:halo_elixir_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HaloElixirAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
