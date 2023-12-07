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

  def part2(args) do
    args
    |> String.split("\n")
    |> Stream.map(&find_number/1)
    |> Enum.sum()
  end

  defp find_number(binary, acc \\ [])

  @digits ~w[zero one two three four five six seven eight nine]

  for {letters, integer} <- Enum.with_index(@digits) do
    # letters
    <<head, tail::binary>> = letters

    defp find_number(<<unquote(head), unquote(tail), rest::binary>>, []) do
      find_number(unquote(tail) <> rest, [unquote(integer)])
    end

    defp find_number(<<unquote(head), unquote(tail), rest::binary>>, [first | _rest]) do
      find_number(unquote(tail) <> rest, [first, unquote(integer)])
    end

    # digit
    <<codepoint>> = Integer.to_string(integer)

    defp find_number(<<unquote(codepoint), rest::binary>>, []) do
      find_number(rest, [unquote(integer)])
    end

    defp find_number(<<unquote(codepoint), rest::binary>>, [first | _rest]) do
      find_number(rest, [first, unquote(integer)])
    end
  end

  defp find_number(<<_head, rest::binary>>, acc) do
    find_number(rest, acc)
  end

  defp find_number(<<>>, []) do
    0
  end

  defp find_number(<<>>, [digit]) do
    Integer.undigits([digit, digit])
  end

  defp find_number(<<>>, [first, last]) do
    Integer.undigits([first, last])
  end
end
