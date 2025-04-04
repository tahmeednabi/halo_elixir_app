# FusionAuth Setup

This directory contains the necessary files to deploy FusionAuth both locally for development and on Fly.io for production.

## Local Development

For local development, you can use Docker Compose to run FusionAuth:

```bash
cd fusionauth
docker-compose up -d
```

This will start FusionAuth on http://localhost:9011

### Initial Setup for Local Development

1. Access FusionAuth at http://localhost:9011
2. Complete the setup wizard to create an admin account
3. Create a new application for your Elixir Phoenix app
4. Configure the OAuth settings:
   - Redirect URL: `http://localhost:4000/auth/fusion/callback`
   - Authorized Origins: `http://localhost:4000`
5. Note the Client ID and Client Secret for your application
6. Update your development environment variables:

```bash
export FUSION_CLIENT_ID=your_client_id
export FUSION_CLIENT_SECRET=your_client_secret
export FUSION_URL=http://localhost:9011
```

Or update the values directly in `config/dev.exs`.
# FusionAuth on Fly.io

This directory contains the necessary files to deploy FusionAuth on Fly.io.

## Prerequisites

1. Install the Fly CLI: https://fly.io/docs/hands-on/install-flyctl/
2. Sign up for a Fly.io account: https://fly.io/docs/hands-on/sign-up/
3. Log in to Fly.io: `fly auth login`

## Setup PostgreSQL Database

FusionAuth requires a PostgreSQL database. You can create one on Fly.io:

```bash
fly postgres create --name halo-fusionauth-db --region syd
```

After creating the database, you'll receive connection details. Update the `fly.toml` file with these details:

```toml
[env]
  FUSIONAUTH_DATABASE_URL = "jdbc:postgresql://[DATABASE_HOST]:5432/fusionauth"
  FUSIONAUTH_DATABASE_USERNAME = "[DATABASE_USER]"
  FUSIONAUTH_DATABASE_PASSWORD = "[DATABASE_PASSWORD]"
```

## Deploy FusionAuth

1. Navigate to the fusionauth directory:
   ```bash
   cd fusionauth
   ```

2. Launch the app on Fly.io:
   ```bash
   fly launch --name halo-fusionauth
   ```

3. Deploy the app:
   ```bash
   fly deploy
   ```

4. Once deployed, you can access FusionAuth at:
   ```
   https://halo-fusionauth.fly.dev
   ```

## Initial Setup

1. When you first access FusionAuth, you'll need to set up an admin account.
2. Create a new application for your Elixir Phoenix app.
3. Configure the OAuth settings:
   - Redirect URL: `https://your-phoenix-app.fly.dev/auth/fusion/callback`
   - Authorized Origins: `https://your-phoenix-app.fly.dev`

4. Note the Client ID and Client Secret for your application.

## Configure Your Phoenix App

Update your Phoenix app's configuration with the FusionAuth details:

```elixir
# config/runtime.exs
config :ueberauth, Ueberauth.Strategy.Fusion.OAuth,
  client_id: System.get_env("FUSION_CLIENT_ID"),
  client_secret: System.get_env("FUSION_CLIENT_SECRET"),
  fusion_url: "https://halo-fusionauth.fly.dev"
```

Set these environment variables in your Phoenix app's deployment:

```bash
fly secrets set FUSION_CLIENT_ID=your_client_id FUSION_CLIENT_SECRET=your_client_secret --app your-phoenix-app
```
