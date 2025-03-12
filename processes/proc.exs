defmodule ProcessDemo do
  def pmap(n) do
    1..n
    |> Enum.map(&ProcessDemo.do_spawn/1)
    |> Enum.map(&ProcessDemo.do_receive/1)
    |> IO.inspect()
  end

  def do_spawn(n) do
    func = fn n -> n * n end

    spawn_link(ProcessDemo, :calc, [self(), func, n])
  end

  def calc(that_process, func, elem) do
    send(that_process, {self(), func.(elem)})
  end

  def do_receive(pid) do
    receive do
      {^pid, result} -> result
      after 100 -> nil
    end
  end

  def run(n) do
    {ms1, res1} = :timer.tc(ProcessDemo, :pmap, [n])
    {ms2, res2} = :timer.tc(Enum, :map, [1..n, &(&1 * &1)])

    (ms1 / 1000)
    |> IO.inspect()

    (ms2 / 1000)
    |> IO.inspect()
  end
end

ProcessDemo.run(50)
