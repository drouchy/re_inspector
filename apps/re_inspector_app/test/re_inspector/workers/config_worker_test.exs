defmodule ReInspector.App.Workers.ConfigWorkerTest do
  use ExUnit.Case, async: true
  import Mock

  alias ReInspector.App.Workers.ConfigWorker

  # handle_call/3
  test_with_mock "it replies with the config version", ReInspector.App.Config, [version: fn -> "version" end] do
    { :reply, "version", _ } = ConfigWorker.handle_call(:version, {self, nil}, nil)
  end
end
