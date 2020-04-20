require './test/test_helper'
require './lib/encryption_algorithm'

class CrackerTest < MiniTest::Test
  def test_it_can_crack_a_cipher
    expected = {
      decryption: "hello world end",
      date: "291018",
      key: "08304"
    }
    assert_equal expected, @enigma.crack("vjqtbeaweqihssi", "291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal expected, @enigma.crack("vjqtbeaweqihssi")
  end

  def test_crack_key
    assert_equal "08304", @enigma.crack_key("vjqtbeaweqihssi","291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal "08304", @enigma.crack_key("vjqtbeaweqihssi", nil)
  end
end
