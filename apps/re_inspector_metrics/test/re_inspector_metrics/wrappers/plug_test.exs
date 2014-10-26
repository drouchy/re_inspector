defmodule ReInspector.Metrics.PlugTest do
  use ExUnit.Case

  alias ReInspector.Metrics.Plug

  # init/1
  test "returns the opts given" do
    :options = Plug.init(:options)
  end
end
