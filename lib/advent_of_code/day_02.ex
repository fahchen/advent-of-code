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

  def part2(_args) do
  end
end
