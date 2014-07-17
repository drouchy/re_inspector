use Mix.Config

config :database,
  database: "re_inspector_test"

config :redis,
  port: 16379,
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
  compress: true
