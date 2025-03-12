defmodule FileReader do
  @moduledoc false
  def typewrite(filename) do
    File.open(filename, [:read])
    |> handle_open()
  end

  defp handle_open({:ok, io_device}) do
    io_device
    |> read_by_line()
    |> File.close()
  end

  defp handle_open({:error, reason}) do
    reason |> IO.inspect(label: "Error: ")
  end

  defp read_by_line(io_device) do
    io_device
    |> IO.read(:eof)
    |> case do
      :eof -> ""
      string -> string
    end
    |> String.split("\n")
    |> print_line(io_device)
  end

  defp print_line(chardata, io_device) do
    do_sleep(5)

    Enum.with_index(chardata, fn elem, idx ->
      IO.write("#{idx + 1} line: ")

      elem
      |> String.split("")
      |> Enum.each(&print_char/1)

      IO.write("\n")
    end)

    File.close(io_device)
  end

  defp print_char(char) do
    char
    |> IO.write()

    do_sleep(100)
  end

  defp do_sleep(value) do
    :timer.sleep(value)
  end
end

FileReader.typewrite("input.txt")
