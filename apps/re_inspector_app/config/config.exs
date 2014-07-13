use Mix.Config

config :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :redis,
  host: "localhost",
  port: 16379,
  list: "re_inceptor"

import_config "#{Mix.env}.exs"
