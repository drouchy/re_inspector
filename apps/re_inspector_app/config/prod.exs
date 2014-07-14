use Mix.Config

config :database,
  database: "re_inspector"

config :exlager,
  level: :info,
  truncation_size: 8096

config :re_inspector,
  correlators: []
