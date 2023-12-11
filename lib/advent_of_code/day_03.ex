defmodule AdventOfCode.Day03 do
  defmodule Part1 do
    @spec pull_adjacent_numbers(sum :: non_neg_integer(), list(Number.t()), adjacent_indices()) ::
            {rest :: list(Number.t()), sum :: non_neg_integer()}
    def pull_adjacent_numbers(sum, numbers, adjacent_indices) do
      Enum.flat_map_reduce(numbers, sum, fn number, acc ->
        if Enum.any?(number.first_index..number.last_index, &MapSet.member?(adjacent_indices, &1)) do
          {[], acc + number.value}
        else
          {[number], acc}
        end
      end)
    end

    defmodule Number do
      @enforce_keys [:value, :first_index, :last_index]
      defstruct value: nil, first_index: nil, last_index: nil

      @type t() :: %__MODULE__{
              value: non_neg_integer(),
              # zero-based index
              first_index: non_neg_integer(),
              last_index: non_neg_integer()
            }
    end

    @typep adjacent_indices :: MapSet.t(non_neg_integer())

    @typep result() :: {
             list(Number.t()),
             {
               upper :: adjacent_indices(),
               current :: adjacent_indices(),
               lower :: adjacent_indices()
             }
           }
    @spec scan_line(
            binary(),
            index :: non_neg_integer(),
            acc :: list(non_neg_integer()),
            result()
          ) ::
            result()
    def scan_line(binary, index \\ 0, acc \\ [], result)

    for digit_int <- 0..9 do
      digit_str = Integer.to_string(digit_int)

      def scan_line(<<unquote(digit_str), rest::binary>>, index, acc, result_acc) do
        scan_line(rest, index + 1, [unquote(digit_int) | acc], result_acc)
      end
    end

    @period "."
    def scan_line(<<@period, rest::binary>>, index, acc, {numbers, adjacent_indices}) do
      numbers =
        if number = list_to_number(acc, index) do
          [number | numbers]
        else
          numbers
        end

      scan_line(rest, index + 1, [], {numbers, adjacent_indices})
    end

    def scan_line(
          <<_symbol::utf8, rest::binary>>,
          index,
          acc,
          {numbers, {upper, current, lower}}
        ) do
      numbers =
        if number = list_to_number(acc, index) do
          [number | numbers]
        else
          numbers
        end

      new_indices = MapSet.new([index - 1, index, index + 1])

      scan_line(
        rest,
        index + 1,
        [],
        {
          numbers,
          {
            MapSet.union(upper, new_indices),
            MapSet.union(current, new_indices),
            MapSet.union(lower, new_indices)
          }
        }
      )
    end

    def scan_line(<<>>, index, acc, {numbers, adjacent_indices}) do
      numbers =
        if number = list_to_number(acc, index) do
          [number | numbers]
        else
          numbers
        end

      {numbers, adjacent_indices}
    end

    @spec list_to_number(list(non_neg_integer()), non_neg_integer()) :: Number.t() | nil
    defp list_to_number([], _index), do: nil

    defp list_to_number([_ | _] = list, index) do
      value = Integer.undigits(Enum.reverse(list))

      %Number{
        value: value,
        first_index: index - length(list),
        last_index: index - 1
      }
    end
  end

  def part1(input) do
    import Part1

    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(
      {_sum = 0, _upper_numbers = [], {_upper = MapSet.new(), _current = MapSet.new()}},
      fn line, {sum, upper_numbers, {upper, current}} ->
        {current_numbers, {upper, current, lower}} =
          scan_line(line, {[], {upper, current, MapSet.new()}})

        {_rest, sum} = pull_adjacent_numbers(sum, upper_numbers, upper)

        {sum, current_numbers, {current, lower}}
      end
    )
    |> then(fn {sum, current_numbers, {current, _lower}} ->
      {_rest, sum} = pull_adjacent_numbers(sum, current_numbers, current)

      sum
    end)
  end

  def part2(_args) do
  end
end
