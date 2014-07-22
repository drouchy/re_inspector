use Mix.Config

config :database,
  login: "postgres",
  database: "re_inspector_ci_test"

config :listeners,
  redis: [
    %{
      name: "local",
      host: "localhost_ci_test",
      port: 16379,
      list: "re_inspector"
    }
  ]

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