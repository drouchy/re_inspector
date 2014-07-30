# This file is responsible for configuring your application
# and its dependencies. The Mix.Config module provides functions
# to aid in doing so.
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
  ],
  rabbitmq: [
    %{
      host: System.get_env("RABBITMQ_HOST"),
      user: System.get_env("RABBITMQ_USER"),
      vhost: System.get_env("RABBITMQ_VHOST"),
      password: System.get_env("RABBITMQ_PASSWORD")
    }
  ]

config :authentication,
  enabled: false,
  providers: ["github"]

config :github,
  client_id: "myclient_id",
  client_secret: "myclientsecret"

config :worker_pools,
  search: %{
    size: 3,
    max_overflow: 5
  }

import_config "#{Mix.env}.exs"
