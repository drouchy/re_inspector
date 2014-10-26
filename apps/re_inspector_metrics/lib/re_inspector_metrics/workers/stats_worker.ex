defmodule ReInspector.Metrics.Workers.StatsWorker do
  use GenServer

  alias ReInspector.Metrics.Statman

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :stats_worker])
  end

  def handle_cast({:web_transaction, [path: path, total: total]}, state) do
    send_to_statman(path, total)
    {:noreply, state}
  end

  def handle_cast({:web_transaction, [path: path, from: from, to: to]}, state) do
    total = :timer.now_diff(to, from)
    send_to_statman(path, total)
    {:noreply, state}
  end

  defp send_to_statman(path, total) do
    Statman.histogram {path, :total}, total
  end
end
