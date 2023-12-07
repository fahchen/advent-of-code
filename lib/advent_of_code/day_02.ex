defmodule AdventOfCode.Day02 do
  @type info() :: {
          red :: non_neg_integer(),
          green :: non_neg_integer(),
          blue :: non_neg_integer()
        }

  @end_of_game :eog

  @spec part1(binary(), info()) :: integer()
  def part1(input, info) do
    input
    |> String.split("\n")
    |> Stream.reject(&(String.trim(&1) == ""))
    |> Stream.flat_map(fn line ->
      ["Game " <> id_str, game_str] = String.split(line, ":", parts: 2)

      if is_game_possible?(game_str, info) do
        [String.to_integer(id_str)]
      else
        []
      end
    end)
    |> Enum.sum()
  end

  defp is_game_possible?(game_str, {red, green, blue} = info) do
    case pop_color(game_str) do
      {{:red, count}, rest_str} when count <= red ->
        is_game_possible?(rest_str, info)

      {{:green, count}, rest_str} when count <= green ->
        is_game_possible?(rest_str, info)

      {{:blue, count}, rest_str} when count <= blue ->
        is_game_possible?(rest_str, info)

      @end_of_game ->
        true

      _otherwise ->
        false
    end
  end

  defp pop_color(set_str, digits \\ [])

  for i <- 0..9 do
    number = Integer.to_string(i)

    defp pop_color(<<unquote(number), rest::binary>>, digits) do
      pop_color(rest, [unquote(i) | digits])
    end
  end

  for color <- ~w[red green blue]a do
    color_str = Atom.to_string(color)

    defp pop_color(<<unquote(color_str), rest::binary>>, digits) do
      count = Integer.undigits(Enum.reverse(digits))

      {{unquote(color), count}, rest}
    end
  end

  defp pop_color(<<stop, rest::binary>>, digits) when stop in [?\s, ?,, ?;] do
    pop_color(rest, digits)
  end

  defp pop_color(<<>>, []), do: @end_of_game

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.reject(&(String.trim(&1) == ""))
    |> Stream.map(fn line ->
      [_game_no_str, game_str] = String.split(line, ":", parts: 2)

      {red, green, blue} = get_info(game_str)

      red * green * blue
    end)
    |> Enum.sum()
  end

  defp get_info(game_str, info \\ {0, 0, 0})

  defp get_info(game_str, {red, green, blue}) do
    case pop_color(game_str) do
      {{:red, count}, rest_str} when count > red ->
        get_info(rest_str, {count, green, blue})

      {{:green, count}, rest_str} when count > green ->
        get_info(rest_str, {red, count, blue})

      {{:blue, count}, rest_str} when count > blue ->
        get_info(rest_str, {red, green, count})

      @end_of_game ->
        {red, green, blue}

      {{_color, _count}, rest_str} ->
        get_info(rest_str, {red, green, blue})
    end
  end
end
