import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :takso, Takso.Repo,
  username: "postgres",
  password: "agile",
  hostname: "localhost",
  database: "takso_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :takso, TaksoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],  # Be sure the port is 4001
  secret_key_base: "UH/VRCXMHQrQSNVp97wWff2GOUofjzD6WzFP1RJW+4CHaZocOHqroCqm3CsckEqv",
  server: true  # Change the `false` to `true`

# In test we don't send emails
config :takso, Takso.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :hound, driver: "chrome_driver", port: 56251  # If needed, update the port according to the chrome_drive message
config :takso, sql_sandbox: true
