use Mix.Config

config :phoenix, ReInspector.Backend.Router,
  url: [host: "localhost"],
  http: [port: 4000],
  https: false,
  secret_key_base: "5$9D78BBM(F3XWS^+IY*RYD+MQ!9_8G2Q!091P@XU%@96LB)G25B#CT0P1LSD($E*^4GKGX4U(Q#FVO",
  catch_errors: true,
  debug_errors: false,
  error_controller: ReInspector.Backend.Controllers.HomeController

config :phoenix, ReInspector.Backend.Router,
  session: [store: :cookie,
            key: "_re_inspector/backend_key"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :re_inspector_app, :worker_pools,
  search: [
    size: 3,
    max_overflow: 5
  ],
  processor: [
    size: 30,
    max_overflow: 50
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

config :metrics,
  enabled: true,
  backend: "new_relic",
  application_name: 'V2::Staging::Inspector',
  license_key: '8cba93cae6afd6afc7aea6e61611f63aa54ac360'

import_config "#{Mix.env}.exs"
