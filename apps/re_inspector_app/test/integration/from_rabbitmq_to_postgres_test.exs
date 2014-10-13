defmodule FromRabbitmqToPostgresTest do
  use ExUnit.Case, async: false
  use Webtest.Case

  import ReInspector.Support.RabbitMQ
  import ReInspector.Support.Ecto
  import ReInspector.Support.Fixtures
  import ReInspector.App.Connections.RabbitMQ

  setup do
    prepare_rabbit
    purge_queues
    clean_db
    on_exit fn ->
      purge_queues
      clean_db
    end
    :ok
  end

  test "when a message arrives in RabbitMQ, it's transformed and persisted into postgres" do
    publish channel, "re_inspector.api_request", "re_inspector.new_request", default_fixture
    publish channel, "re_inspector.api_request", "re_inspector.new_request", default_fixture

    with_retries 20, 100 do
      assert count_api_requests == 2
    end

    assert first_api_request.service_name == "service 1"
  end

  test "end-to-end correlation test - from rabbitmq to postgres and correlated" do
    publish channel, "re_inspector.api_request", "re_inspector.new_request", default_fixture
    publish channel, "re_inspector.api_request", "re_inspector.new_request", default_fixture

    with_retries 20, 100 do
      assert count_api_requests == 2
      assert count_uncorrelated_requests == 0
    end

    [first_api_request|_] = all_api_requests
    assert first_api_request.service_name == "service 1"
    assert first_api_request.correlator_name == "Elixir.ReInspector.Test.Service1Correlator"
  end
end
