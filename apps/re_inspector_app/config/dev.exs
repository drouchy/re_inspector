use Mix.Config

config :logger, level: :debug

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector_development"
