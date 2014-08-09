# This file is responsible for configuring your application
# and its dependencies. The Mix.Config module provides functions
# to aid in doing so.
use Mix.Config

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :re_inspector_app, :listeners,
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

config :re_inspector_app, :worker_pools,
  search: %{
    size: 3,
    max_overflow: 5
  }

config :re_inspector_app,
  retention_in_weeks: 6,
  correlators: []

config :re_inspector_backend, :authentication,
  enabled: false,
  providers: ["github"]

config :re_inspector_backend, :github,
  client_id: "myclient_id",
  client_secret: "myclientsecret"

import_config "#{Mix.env}.exs"
