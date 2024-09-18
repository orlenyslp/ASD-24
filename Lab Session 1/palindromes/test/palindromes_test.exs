defmodule PalindromesTest do
  use ExUnit.Case

  # @tag :skip
  test "reverses a given charlist" do
    assert Palindromes.reverse(~c"abracadabra") == ~c"arbadacarba"
    assert Palindromes.reverse(~c"Panama") == ~c"amanaP"
  end

  # @tag :skip
  test "replaces any lowercase character in a given charlist by its corresponding uppercase" do
    assert Palindromes.upcase(~c"abracadabra") == ~c"ABRACADABRA"
    assert Palindromes.upcase(~c"Panama") == ~c"PANAMA"
  end

  # @tag :skip
  test "removes non alphabetical caracters from a given charlist" do
    assert Palindromes.remove_non_alpha(~c"w o r d") == ~c"word"
    assert Palindromes.remove_non_alpha(~c"w1o2r3d") == ~c"word"
  end

  # @tag :skip
  test "checks simple words" do
    assert Palindromes.palindrome(~c"redivider") == true
    assert Palindromes.palindrome(~c"abracadabra") == false
  end

  # @tag :skip
  test "checks words, case insensitively" do
    assert Palindromes.palindrome(~c"ReDivider") == true
  end

  # @tag :skip
  test "ignores non alphabetic characters" do
    assert Palindromes.palindrome(~c"A man, a plan, a canal -- Panama") == true
    assert Palindromes.palindrome(~c"Madam, I\'m Adam!") == true
  end
end
