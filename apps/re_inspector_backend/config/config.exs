use Mix.Config

config :phoenix, ReInspector.Backend.Router,
  port: 4000,
  ssl: false,
  code_reload: false,
  cookies: true,
  session_key: "_re_inspector_backend_key",
  session_secret: "5$9D78BBM(F3XWS^+IY*RYD+MQ!9_8G2Q!091P@XU%@96LB)G25B#CT0P1LSD($E*^4GKGX4U(Q#FVO"

config :phoenix, :logger,
  level: :error

config :re_inspector_app, :worker_pools,
  search: [
    size: 3,
    max_overflow: 5
  ],
  processor: [
    size: 3,
    max_overflow: 5
  ]

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :re_inspector_app, :listeners,
  redis: [],
  rabbitmq: [],
  aws: []

config :re_inspector_app, :re_inspector,
  correlators: [],
  retention_in_weeks: 6

config :re_inspector_backend, :authentication,
  enabled: true,
  providers: ["github"]

config :re_inspector_backend, :github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

import_config "#{Mix.env}.exs"
