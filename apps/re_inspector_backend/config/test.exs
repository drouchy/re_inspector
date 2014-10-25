use Mix.Config

config :logger, level: :error

config :phoenix, ReInspector.Backend.Router,
  http: [port: 4010],
  catch_errors: false

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector_test"

config :re_inspector_app, :listeners,
  redis: [],
  rabbitmq: [],
  aws: []

config :re_inspector_app,
  correlators: []

config :re_inspector_backend, :authentication,
  enabled: false,
  providers: []

config :re_inspector_backend, :github,
  client_id: "GITHUB_CLIENT_ID",
  client_secret: "GITHUB_CLIENT_SECRET"
