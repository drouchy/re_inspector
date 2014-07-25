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

config :worker_pools,
  search: %{
    size: 3,
    max_overflow: 5
  }
import_config "#{Mix.env}.exs"
