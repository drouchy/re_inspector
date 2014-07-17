# This file is responsible for configuring your application
# and its dependencies. The Mix.Config module provides functions
# to aid in doing so.
use Mix.Config

config :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :redis,
  host: "localhost",
  port: 6379,
  list: "re_inceptor"

config :web,
  port: 4000,
  compress: true

import_config "#{Mix.env}.exs"
