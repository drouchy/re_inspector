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
  port: 16379,
  list: "re_inceptor"

import_config "#{Mix.env}.exs"
