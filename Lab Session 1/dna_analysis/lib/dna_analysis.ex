defmodule DnaAnalysis do

  def count([], _n), do: 0
  def count([head | tail], n) when head == n, do: 1 + count(tail, n)
  def count([_head | tail], n), do: count(tail, n)

  def histogram(dna), do: %{?A => count(dna, ?A),
                            ?T => count(dna, ?T),
                            ?C => count(dna, ?C),
                            ?G => count(dna, ?G)}

end
