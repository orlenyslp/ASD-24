defmodule DnaAnalysisTest do
  use ExUnit.Case

  # @tag :skip
  test "empty dna string has no adenine" do
    assert DnaAnalysis.count(~c"", ?A) == 0
  end

  # @tag :skip
  test "repetitive cytosine gets counted" do
    assert DnaAnalysis.count(~C"CCCCC", ?C) == 5
  end

  # @tag :skip
  test "counts only thymine" do
    assert DnaAnalysis.count(~C"GGGGGTAACCCGG", ?T) == 1
  end

  # @tag :skip
  test "empty dna string has no nucleotides" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
    assert DnaAnalysis.histogram(~C"") == expected
  end

  # @tag :skip
  test "repetitive sequence has only guanine" do
    expected = %{?A => 0, ?T => 0, ?C => 0, ?G => 8}
    assert DnaAnalysis.histogram(~C"GGGGGGGG") == expected
  end

  # @tag :skip
  test "counts all nucleotides" do
    s = ~C"AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"
    expected = %{?A => 20, ?T => 21, ?C => 12, ?G => 17}
    assert DnaAnalysis.histogram(s) == expected
  end
end
