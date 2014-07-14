use Mix.Config

config :database,
  database: "re_inspector_development"

config :exlager,
  level: :debug,
  truncation_size: 8096

config :re_inspector,
  correlators: []
