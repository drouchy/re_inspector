use Mix.Config

config :phoenix, ReInspector.Backend.Router,
  port: 4010,
  ssl: false,
  code_reload: false,
  cookies: true,
  consider_all_requests_local: true,
  session_key: "_re_inspector_backend_key",
  session_secret: "5$9D78BBM(F3XWS^+IY*RYD+MQ!9_8G2Q!091P@XU%@96LB)G25B#CT0P1LSD($E*^4GKGX4U(Q#FVO"

config :phoenix, :logger,
  level: :emergency

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  database: "re_inspector_test"

config :re_inspector_app, :listeners,
  redis: [
    %{
      name: "test",
      host: "localhost",
      port: 16379,
      list: "re_inspector_test"
    }
  ],
  rabbitmq: [
    %{
      name: "local",
      host: "localhost",
      virtual_host: "re_inspector_test",
      username: "guest",
      password: "guest"
    }
  ]

config :re_inspector_app,
  correlators: [
    ReInspector.Test.Service1Correlator,
    ReInspector.Test.Service2Correlator
  ]

config :exlager,
  level: :emergency,
  truncation_size: 8096
