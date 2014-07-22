# This file is responsible for configuring your application
# and its dependencies. The Mix.Config module provides functions
# to aid in doing so.
use Mix.Config

config :database,
  host: "localhost",
  login: "re_inspector",
  password: nil,
  database: "re_inspector"

config :listeners,
  redis: [
    %{
      name: "local",
      host: "localhost",
      port: 16379,
      list: "re_inspector"
    }
  ]

config :web,
  port: 4000,
  compress: true,
  host: "http://localhost:8080"

config :authentication,
  enabled: true,
  providers: ["github"]

config :github,
  client_id: "59eca5038dee208a43dc",
  client_secret: "eaef16f776c2a4383bd3f574ab2ce6e23bdf9426"

import_config "#{Mix.env}.exs"
