require './test/test_helper'
require './lib/encryption_algorithm'

class CrackerTest < MiniTest::Test

  def setup
    @cracker = Cracker.new(message, date)
    @cracker_default_date = Cracker.new(message)
  end

  def test_it_exists
    assert_instance_of Cracker, @cracker
    assert_instance_of Cracker, @cracker_default_date
  end

  def test_it_has_readable_attributes
    assert_equal "vjqtbeaweqihssi", @cracker.message
    assert_equal "vjqtbeaweqihssi", @cracker_default_date.message
    assert_equal "291018", @cracker.date
    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal "291018", @cracker_default_date.date
  end

  def test_it_can_crack_a_cipher
    expected = {
      decryption: "hello world end",
      date: "291018",
      key: "08304"
    }
    assert_equal expected, @@cracker.crack("vjqtbeaweqihssi", "291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal expected, @@cracker.crack("vjqtbeaweqihssi")
  end

  def test_crack_key
    assert_equal "08304", @@cracker.crack_key("vjqtbeaweqihssi","291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal "08304", @@cracker.crack_key("vjqtbeaweqihssi", nil)
  end
end
