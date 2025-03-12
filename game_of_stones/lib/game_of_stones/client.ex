defmodule GameOfStones.Client do
  @ask_stone_in_game "\nPlease take from 1 to 3 stones:\n"
  @ask_count_stone "\nPlease enter count of stones:\n"
  @server GameOfStones.Server

  def main(argv) do
    parse(argv)
    |> set_initial_stones()

    next_turn()
  end

  defp parse(arguments) do
    {opts, _, _} = OptionParser.parse(arguments, switches: [stones: :integer])
    opts |> Keyword.get(:stones, Application.get_env(:game_of_stones, :default_stones))
  end

  defp set_initial_stones(stones_to_set) do
    case GenServer.call(@server, {:set, stones_to_set}) do
      {:stones_set, player, num_stones} ->
        IO.puts("Welcome! It's player #{player} turn. #{num_stones} in the pile.")

      {:error, reason} ->
        IO.puts("\nThere was an error: #{reason}")
        exit(:normal)
    end
  end

  defp next_turn() do
    case GenServer.call(@server, {:take, ask_stones(@ask_stone_in_game)}) do
      {:next_turn, next_player, stones_count} ->
        IO.puts("\nPlayer #{next_player} turns next. Stones: #{stones_count}")
        next_turn()

      {:winner, winner} ->
        IO.puts("\nPlayer #{winner} wins!!!")
        ask_new_game()

      {:error, reason} ->
        IO.puts("\nThere was an error: #{reason}")
        next_turn()
    end
  end

  defp ask_new_game() do
    IO.gets("\nWould you like to start a new game?(y/n):\n")
    |> String.trim()
    |> String.downcase()
    |> start_new_game()
  end

  defp start_new_game("y") do
    stones = ask_stones(@ask_count_stone)
    main(["--stones", Integer.to_string(stones)])
  end
  defp start_new_game("n"), do: IO.puts("Bye, Bye")
  defp start_new_game(_) do
    IO.puts("\nPlease enter 'y'(yes) or 'n'(no)\n")
    ask_new_game()
  end

  defp ask_stones(question) do
    IO.gets(question)
    |> String.trim()
    |> Integer.parse()
    |> stones_to_take()
  end

  defp stones_to_take({count, _}), do: count
  defp stones_to_take(:error), do: 0
end
