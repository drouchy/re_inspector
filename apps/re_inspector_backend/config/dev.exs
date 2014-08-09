use Mix.Config

config :phoenix, ReInspector.Backend.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  code_reload: true,
  cookies: true,
  consider_all_requests_local: true,
  session_key: "_re_inspector_backend_key",
  session_secret: "5$9D78BBM(F3XWS^+IY*RYD+MQ!9_8G2Q!091P@XU%@96LB)G25B#CT0P1LSD($E*^4GKGX4U(Q#FVO"

config :phoenix, :logger,
  level: :debug

config :exlager,
  level: :debug,
  truncation_size: 8096

config :re_inspector_app, :listeners,
  redis: [
    [
      name: "local",
      host: "localhost",
      port: 16379,
      list: "re_inspector"
    ]
  ],
  rabbitmq: []

config :re_inspector_app, :database,
  database: "re_inspector_development"

config :re_inspector_app,
  correlators: [
    ReInspector.Test.Service1Correlator,
    ReInspector.Test.Service2Correlator
  ],
  broadcast_command: &ReInspector.Backend.BroadcastingService.new_request/1
