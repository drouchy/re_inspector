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
      port: 6379,
      list: "re_inspector"
    ]
  ],
  rabbitmq: [
    [
      name: "cloudamqp",
      host: System.get_env("RABBITMQ_HOST"),
      virtual_host: System.get_env("RABBITMQ_VHOST"),
      username: System.get_env("RABBITMQ_USER"),
      password: System.get_env("RABBITMQ_PASSWORD")
    ]
  ],
  aws: [
    [
      name: "re_inspector_dev",
      access_client_id: System.get_env("AWS_CLIENT_ID"),
      access_client_secret: System.get_env("AWS_CLIENT_SECRET"),
      topic: "re_inspector-new_api_request-dev",
      sqs_host: "queue.amazonaws.com",
      sns_host: "sns.us-east-1.amazonaws.com"
    ]
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

config :metrics,
  enabled: true,
  backend: "new_relic",
  application_name: "re_inspector_metrics_app",
  license_key: "newrelic-license-key"

import_config "#{Mix.env}.exs"
