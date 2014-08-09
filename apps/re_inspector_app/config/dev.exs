use Mix.Config

config :re_inspector_app, :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector_development"

config :exlager,
  level: :debug,
  truncation_size: 8096
