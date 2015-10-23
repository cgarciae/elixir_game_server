use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :game_server, GameServer.Endpoint,
  secret_key_base: "Gq54xM1Fdnzua3sP41EcJS3mlsAV3DyJCDhZ1hSNyFiGUSSSBuz8bGdy/lvoqr/a"

# Configure your database
config :game_server, GameServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "game_server_prod",
  pool_size: 20
