defmodule ErrorProcessingTest do
  use ExUnit.Case, async: false
  use Webtest.Case
  use Exredis

  import ReInspector.Support.Redis
  import ReInspector.Support.Ecto

  setup do
    clear_redis
    clean_db
    on_exit fn ->
      clear_redis
      clean_db
    end
    :ok
  end

  test "When an invalid message is inserted in redis, a processing error is created" do
    redis_connection |> query ["RPUSH", redis_list, "{"]

    with_retries 10, 200 do
      assert first_processing_error != nil
    end

    error = first_processing_error
    assert error != nil
    assert error.message == "only the nil atom is supported"
  end

  test "When an invalid message is inserted in postgres, a processing error is created" do
    api_request = ReInspector.Repo.insert %ReInspector.ApiRequest{}

    ReInspector.App.process_api_request api_request.id

    with_retries 10, 100 do
      assert first_processing_error != nil
    end

    error = first_processing_error_with_api_request
    assert error != nil
    assert error.message == "undefined"
    assert error.api_request.get == api_request
  end
end
