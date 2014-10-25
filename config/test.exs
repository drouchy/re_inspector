use Mix.Config

config :logger, level: :debug

config :phoenix, ReInspector.Backend.Router,
  http: [port: 4010],
  catch_errors: false

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector_test"

config :re_inspector_app, :listeners,
  redis: [
    [
      name: "test",
      host: "localhost",
      port: 16379,
      list: "re_inspector_test"
    ]
  ],
  rabbitmq: [
    [
      name: "local",
      host: "localhost",
      virtual_host: "re_inspector_test",
      username: "guest",
      password: "guest"
    ]
  ],
  aws: []

config :re_inspector_app,
  correlators: [
    ReInspector.Test.Service1Correlator,
    ReInspector.Test.Service2Correlator
  ],
  retention_in_weeks: 6

config :re_inspector_backend, :authentication,
  enabled: false,
  providers: []

config :re_inspector_backend, :github,
  client_id: "GITHUB_CLIENT_ID",
  client_secret: "GITHUB_CLIENT_SECRET"
