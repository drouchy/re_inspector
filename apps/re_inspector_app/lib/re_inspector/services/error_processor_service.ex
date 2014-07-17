defmodule ReInspector.App.Services.ErrorProcessorService do
  alias ReInspector.Repo
  alias ReInspector.ProcessingError

  def process_error(error, trace) do
    from(error, trace)
    |> Repo.insert
  end

  def inspect_stack_trace(stack_trace) do
    Enum.map stack_trace, fn(trace) -> inspect(trace) end
  end

  def now, do: Ecto.DateTime.from_erl Chronos.now

  def from(error, trace) do
    %ProcessingError{
      message: error.description,
      error: inspect(error),
      trace: inspect_stack_trace(trace),
      created_at: now
    }
  end
end