# HaloElixirApp

A Phoenix chat application with authentication using UeberAuth and FusionAuth.

## Getting Started

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Authentication Setup

This application uses UeberAuth with FusionAuth for authentication. 

### Local Development

For local development:

1. Start the FusionAuth server using Docker Compose:
   ```bash
   cd fusionauth
   docker-compose up -d
   ```

2. Access FusionAuth at http://localhost:9011 and complete the setup:
   - Create an admin account
   - Create a new application for your Phoenix app
   - Configure OAuth settings (see fusionauth/README.md for details)

3. Update your environment variables or config/dev.exs with your FusionAuth credentials:
   ```bash
   export FUSION_CLIENT_ID=your_client_id
   export FUSION_CLIENT_SECRET=your_client_secret
   export FUSION_URL=http://localhost:9011
   ```

4. Run database migrations:
   ```bash
   mix ecto.migrate
   ```

5. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

### Production Deployment

For production deployment on Fly.io:

1. Deploy FusionAuth to Fly.io (see fusionauth/README.md for detailed instructions)
2. Set the required environment variables for your Phoenix app:
   ```bash
   fly secrets set FUSION_CLIENT_ID=your_client_id FUSION_CLIENT_SECRET=your_client_secret FUSION_URL=https://your-fusionauth-app.fly.dev --app your-phoenix-app
   ```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  * UeberAuth: https://github.com/ueberauth/ueberauth
  * FusionAuth: https://fusionauth.io/
