defmodule FibSolver do
  def fib(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:fib, n, client} ->
        send(client, {:answer, n, fib_calc(n), self()})
        fib(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when queue != [] ->
        [next | tail] = queue
        send(pid, {:fib, next, self()})

        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 2 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end
end

queue = List.duplicate(35, 7)

# {time, result} = :timer.tc(Scheduler,:run, [1, FibSolver,:fib, queue])
# :io.format("~.2f~n", [time / 1_000_000.0])
# Scheduler.run(1,FibSolver, :fib, queue) |> IO.inspect()

Enum.each(1..10, fn num_processes ->
  {time, result} =
    :timer.tc(
      Scheduler,
      :run,
      [num_processes, FibSolver, :fib, queue]
    )

  if num_processes == 1 do
    IO.puts(inspect(result))
    IO.puts("\n # time(sec)")
  end

  :io.format("~2B ~.2f~n", [num_processes, time / 1_000_000.0])
end)
