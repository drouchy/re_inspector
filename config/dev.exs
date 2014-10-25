use Mix.Config

config :logger, level: :debug

config :phoenix, ReInspector.Backend.Router,
  http: [port: 4000],
  debug_errors: true

config :phoenix, :code_reloader, true

config :re_inspector_app, :listeners,
  redis: [
    [
      name: "local",
      host: "localhost",
      port: 16379,
      list: "re_inspector"
    ]
  ],
  rabbitmq: [],
  aws: []

config :re_inspector_app,
  correlators: [
    ReInspector.Test.Service1Correlator,
    ReInspector.Test.Service2Correlator
  ],
  broadcast_command: &ReInspector.Backend.BroadcastingService.new_request/1
