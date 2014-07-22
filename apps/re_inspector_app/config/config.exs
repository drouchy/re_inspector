use Mix.Config

config :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :listeners,
  redis: [
    %{
      name: "local",
      host: "localhost",
      port: 16379,
      list: "re_inspector"
    }
  ]

import_config "#{Mix.env}.exs"
