# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :re_inspector_metrics,
  enabled: true,
  provider: "new_relic",
  application_name: "re_inspector_metrics_app",
  license_key: "newrelic-license-key"

import_config "#{Mix.env}.exs"
