defmodule ReInspector.AppTest do
  use ExUnit.Case
  import Mock

  #version/0
  test "returns the config version" do
    version = ReInspector.App.version

    assert version == ReInspector.App.Mixfile.project[:version]
  end

  #process_error/2
  test_with_mock "call a message for processing error", GenServer, [cast: fn(:re_inspector_error_processor, {:error_raised, :error, :trace, :id}) -> :ok end] do
    ReInspector.App.process_error(:error, :trace, :id)

    assert called GenServer.cast(:re_inspector_error_processor, {:error_raised, :error, :trace, :id})
  end

  test_with_mock "call a message for processing error without any request id", GenServer, [cast: fn(:re_inspector_error_processor, {:error_raised, :error, :trace, nil}) -> :ok end] do
    ReInspector.App.process_error(:error, :trace)

    assert called GenServer.cast(:re_inspector_error_processor, {:error_raised, :error, :trace, nil})
  end

  #clean_old_data/0
  test_with_mock "cast a message for cleaning old data", GenServer, [cast: fn(:re_inspector_data_cleaner, :clean_old_data) -> :ok end] do
    ReInspector.App.clean_old_data

    assert called GenServer.cast(:re_inspector_data_cleaner, :clean_old_data)
  end
end
