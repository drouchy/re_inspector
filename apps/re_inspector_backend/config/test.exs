use Mix.Config

config :database,
  database: "re_inspector_test"

config :redis,
  list: "re_inspector_test"

config :exlager,
  level: :emergency,
  truncation_size: 8096

config :re_inspector,
  correlators: [
    ReInspector.Test.Service1Correlator,
    ReInspector.Test.Service2Correlator
  ]

config :web,
  port: 4010,
  compress: true,
  host: "http://re_inspector.example.com"

config :authentication,
  enabled: false,
  providers: ["github"]

config :github,
  client_id: "myclient_id",
  client_secret: "myclientsecret"
