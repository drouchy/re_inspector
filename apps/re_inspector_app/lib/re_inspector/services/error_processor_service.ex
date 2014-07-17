defmodule ReInspector.App.Services.ErrorProcessorService do
  alias ReInspector.Repo
  alias ReInspector.ProcessingError

  def process_error(error, trace) do
    process_error(error, trace, nil)
  end

  def process_error(error, trace, api_request_id) do
    from(error, trace, api_request_id)
    |> Repo.insert
  end

  def inspect_stack_trace(stack_trace) do
    Enum.map stack_trace, fn(trace) -> inspect(trace) end
  end

  def now, do: Ecto.DateTime.from_erl Chronos.now

  def from(error, trace, api_request_id) do
    %ProcessingError{
      message: error_description(error),
      error: inspect(error),
      trace: inspect_stack_trace(trace),
      created_at: now,
      api_request_id: api_request_id
    }
  end

  # not sure how to that correctly wihtout try/catch
  def error_description(error) do
    try do
      error.description
    rescue
      KeyError -> "undefined"
    end
  end
end