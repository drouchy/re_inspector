use Mix.Config

config :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

import_config "#{Mix.env}.exs"
