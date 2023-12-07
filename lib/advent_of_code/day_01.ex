defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n")
    |> Stream.map(&find_digits/1)
    |> Enum.sum()
  end

  defp find_digits(binary, acc \\ [])

  for i <- 0..9 do
    <<codepoint>> = Integer.to_string(i)

    defp find_digits(<<unquote(codepoint), rest::binary>>, []) do
      find_digits(rest, [unquote(i)])
    end

    defp find_digits(<<unquote(codepoint), rest::binary>>, [first | _rest]) do
      find_digits(rest, [first, unquote(i)])
    end
  end

  defp find_digits(<<_head, rest::binary>>, acc) do
    find_digits(rest, acc)
  end

  defp find_digits(<<>>, []) do
    0
  end

  defp find_digits(<<>>, [digit]) do
    Integer.undigits([digit, digit])
  end

  defp find_digits(<<>>, [first, last]) do
    Integer.undigits([first, last])
  end

  def part2(_args) do
  end
end
