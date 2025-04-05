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
