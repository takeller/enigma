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
    assert_equal "08304", @cracker.crack_key("vjqtbeaweqihssi")
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

    assert_equal [7, 18, 18, 8], @cracker.find_encrypted_indices(["h", "s", "s", "i"])
    assert_equal [18, 8, 7, 18], @cracker.find_encrypted_indices(["s", "i", "h", "s"])
  end


end
