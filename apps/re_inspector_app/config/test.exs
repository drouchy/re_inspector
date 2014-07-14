use Mix.Config

config :database,
  database: "re_inspector_test"

config :redis,
  list: "re_inspector_test"

config :exlager,
  level: :error,
  truncation_size: 8096
