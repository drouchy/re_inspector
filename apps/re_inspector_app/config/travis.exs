use Mix.Config

config :database,
  login: "postgres",
  database: "re_inspector_ci_test"

config :redis,
  list: "re_inspector_ci_test"

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
  compress: true