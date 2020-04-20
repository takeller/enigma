require './test/test_helper'
require './lib/cracker'

class CrackerTest < MiniTest::Test

  def setup
    @cracker = Cracker.new
  end

  def test_it_exists
    assert_instance_of Cracker, @cracker
  end

  def test_crack_key
    assert_equal "08304", @cracker.crack_key("vjqtbeaweqihssi","291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal "08304", @cracker.crack_key("vjqtbeaweqihssi", nil)
  end

  def test_it_has_an_alphabet
    alphabet = ("a".."z").to_a << " "
    assert_equal alphabet, @cracker.alphabet
  end

  def test_rotate_last_four_characters
    last_four_characters1 = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    last_four_characters2 = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    last_four_characters3 = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    last_four_characters4 = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    expected1 = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    expected2 = {
      encrypted_chars: ["s", "s", "i", "h"],
      decrypted_chars: ["e", "n", "d", " "]
    }
    expected3 = {
      encrypted_chars: ["s", "i", "h", "s"],
      decrypted_chars: ["n", "d", " ", "e"]
    }
    expected4 = {
      encrypted_chars: ["i", "h", "s", "s"],
      decrypted_chars: ["d", " ", "e", "n"]
    }
    assert_equal expected1, @cracker.rotate_last_four_characters(last_four_characters1, 0)
    assert_equal expected2, @cracker.rotate_last_four_characters(last_four_characters2, 3)
    assert_equal expected3, @cracker.rotate_last_four_characters(last_four_characters3, 2)
    assert_equal expected4, @cracker.rotate_last_four_characters(last_four_characters4, 1)
  end

  def test_find_encrypted_indices
    expected1 = {
      a: 7,
      b: 18,
      c: 18,
      d: 8
    }
    expected2 = {
      a: 18,
      b: 8,
      c: 7,
      d: 18
    }
    assert_equal expected1, @cracker.find_encrypted_indices(["h", "s", "s", "i"])
    assert_equal expected2, @cracker.find_encrypted_indices(["s", "i", "h", "s"])
  end

  def test_find_decrypted_indices
    expected1 = {
      a: 26,
      b: 4,
      c: 13,
      d: 3
    }
    expected2 = {
      a: 13,
      b: 3,
      c: 26,
      d: 4
    }

    assert_equal expected1, @cracker.find_decrypted_indices([" ", "e", "n", "d"])
    assert_equal expected2, @cracker.find_decrypted_indices(["n", "d", " ", "e"])
  end

  def test_find_base_shifts
    expected1 = {
      a: -19,
      b: 14,
      c: 5,
      d: 5
    }
    expected2 = {
      a: 5,
      b: 5,
      c: -19,
      d: 14
    }
    encrypted_indices1 = {
      a: 7,
      b: 18,
      c: 18,
      d: 8
    }
    encrypted_indices2 = {
      a: 18,
      b: 8,
      c: 7,
      d: 18
    }
    decrypted_indices1 = {
      a: 26,
      b: 4,
      c: 13,
      d: 3
    }
    decrypted_indices2 = {
      a: 13,
      b: 3,
      c: 26,
      d: 4
    }

    assert_equal expected1, @cracker.find_base_shifts(encrypted_indices1, decrypted_indices1)
    assert_equal expected2, @cracker.find_base_shifts(encrypted_indices2, decrypted_indices2)
  end

  def test_find_possible_shifts
    expected = {
      :a=>[14, 41, 68, 95, 122],
      :b=>[5, 32, 59, 86, 113],
      :c=>[5, 32, 59, 86, 113],
      :d=>[-19, 8, 35, 62, 89]
    }
    base_shifts = {:a=>14, :b=>5, :c=>5, :d=>-19}

    assert_equal expected, @cracker.find_possible_shifts(base_shifts)
  end

  def test_find_possible_keys
    expected = {
      :a=>["08", "35", "62", "89"],
      :b=>["02", "29", "56", "83"],
      :c=>["03", "30", "57", "84"],
      :d=>["04", "31", "58", "85"]
    }
    offsets = {:a_offset=>6, :b_offset=>3, :c_offset=>2, :d_offset=>4}
    shifts = {
      :a=>[14, 41, 68, 95],
      :b=>[5, 32, 59, 86],
      :c=>[5, 32, 59, 86],
      :d=>[8, 35, 62, 89]
    }
    assert_equal expected, @cracker.find_possible_keys(shifts, offsets)
  end

  def test_find_solution_key
    possible_keys = {
      :a=>["08", "35", "62", "89"],
      :b=>["02", "29", "56", "83"],
      :c=>["03", "30", "57", "84"],
      :d=>["04", "31", "58", "85"]
    }
    assert_equal "08304", @cracker.find_solution_key(possible_keys)
  end

  def test_find_key
    last_four_characters = {
      encrypted_chars: ["h", "s", "s", "i"],
      decrypted_chars: [" ", "e", "n", "d"]
    }
    offsets = {:a_offset=>6, :b_offset=>3, :c_offset=>2, :d_offset=>4}
    assert_equal "08304", @cracker.find_key(last_four_characters, 3, offsets)
  end

  def test_build_key
    possible_keys = {
      :a=>["08", "35", "62", "89"],
      :b=>["02", "29", "56", "83"],
      :c=>["03", "30", "57", "84"],
      :d=>["04", "31", "58", "85"]
    }
    a_key = "08"
    assert_equal "08304", @cracker.build_key(possible_keys, a_key)
    a_key = "35"
    assert_nil @cracker.build_key(possible_keys, a_key)
  end

end
