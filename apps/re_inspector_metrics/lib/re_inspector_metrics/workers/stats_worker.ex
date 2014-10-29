defmodule ReInspector.Metrics.Workers.StatsWorker do
  use GenServer

  alias ReInspector.Metrics.Statman

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :stats_worker])
  end

  def handle_cast({:report_transaction, [name: name, total: total]}, state) do
    send_to_statman(name, total)
    {:noreply, state}
  end

  def handle_cast({:report_transaction, [name: name, from: from, to: to]}, state) do
    total = :timer.now_diff(to, from)
    send_to_statman(name, total)
    {:noreply, state}
  end

  defp send_to_statman(name, total) do
    Statman.histogram {name, :total}, total
  end
end
