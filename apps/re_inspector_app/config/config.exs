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
      name: "cloudamqp",
      host: System.get_env("RABBITMQ_HOST"),
      virtual_host: System.get_env("RABBITMQ_VHOST"),
      username: System.get_env("RABBITMQ_USER"),
      password: System.get_env("RABBITMQ_PASSWORD")
    }
  ]

config :worker_pools,
  search: %{
    size: 3,
    max_overflow: 5
  }
import_config "#{Mix.env}.exs"
