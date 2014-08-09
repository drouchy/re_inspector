use Mix.Config

import_config "test.exs"

config :re_inspector_app, :database:
  host: "localhost",
  login: "postgres",
  password: nil,
  database: "re_inspector_ci_test"

config :re_inspector_app, :listeners
  redis: [
    %{
      name: "test",
      host: "localhost",
      port: 6379,
      list: "re_inspector_ci_test"
    }
  ],
  rabbitmq: [
    %{
      name: "local",
      host: "localhost",
      virtual_host: "/",
      username: "guest",
      password: "guest"
    }
  ]
