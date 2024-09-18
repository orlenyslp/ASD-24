defmodule Palindromes do

  def reverse(word), do: reverse(word, [])
  def reverse([], reversed), do: reversed
  def reverse([head | tail], reversed), do: reverse(tail, [head | reversed])

  def upcase([]), do: []
  def upcase([head | tail]) when head in ?a..?z, do: [head - 32 | upcase(tail)]
  def upcase([head | tail]), do: [head | upcase(tail)]

  def remove_non_alpha([]), do: []
  def remove_non_alpha([head | tail]) when head in ?a..?z or head in ?A..?Z, do: [head | remove_non_alpha(tail)]
  def remove_non_alpha([_ | tail]), do: remove_non_alpha(tail)

  def compare(word), do: word == reverse(word)

  def palindrome(word), do: word |> upcase() |> remove_non_alpha() |> compare()

end
