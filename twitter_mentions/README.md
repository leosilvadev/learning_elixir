# Twitter Mentions

Collect and persist all the tweets that mention a specific username.
The username must be configured at ```config/config.exs``` file.

## Docs
```elixir
mix docs
```

## Running with docker-compose
```elixir
docker-compose up --build
```

## All the environment variables
- (required) MIX_ENV
- (required) TWITTER_CONSUMER_KEY
- (required) TWITTER_CONSUMER_SECRET
- (required) TWITTER_ACCESS_TOKEN
- (required) TWITTER_ACCESS_TOKEN_SECRET
- (required) PG_DATABASE
- (required) PG_USERNAME
- (required) PG_PASSWORD
- (required) PG_HOSTNAME
- (optional) PG_PORT, default "5432"
- (required) MENTIONS_USERNAME
- (optional) PG_POOL_SIZE, default "10"
- (optional) MENTIONS_MAX_MENTIONS, default "100"
- (optional) MENTIONS_RETRY_DELAY, default "60000"