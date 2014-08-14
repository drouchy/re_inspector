use Mix.Config

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :re_inspector_app, :listeners,
  redis: [
    [
      name: "local",
      host: "localhost",
      port: 16379,
      list: "re_inspector"
    ]
  ],
  rabbitmq: [
    # [
    #   name: "cloudamqp",
    #   host: System.get_env("RABBITMQ_HOST"),
    #   virtual_host: System.get_env("RABBITMQ_VHOST"),
    #   username: System.get_env("RABBITMQ_USER"),
    #   password: System.get_env("RABBITMQ_PASSWORD")
    # ]
  ]

config :re_inspector_app, :worker_pools,
  search: [
    size: 3,
    max_overflow: 5
  ],
  processor: [
    size: 3,
    max_overflow: 5
  ]

config :re_inspector_app,
  correlators: [],
  retention_in_weeks: 10

import_config "#{Mix.env}.exs"
