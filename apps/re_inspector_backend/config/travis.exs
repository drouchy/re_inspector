use Mix.Config

import_config "test.exs"

config :database,
  host: "localhost",
  login: "postgres",
  database: "re_inspector_ci_test"
