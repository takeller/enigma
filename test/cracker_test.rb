require './test/test_helper'
require './lib/cracker'

class CrackerTest < MiniTest::Test

  def setup
    @cracker = Cracker.new("vjqtbeaweqihssi", "291018")
    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    @cracker_default_date = Cracker.new("vjqtbeaweqihssi")
  end

  def test_it_exists
    assert_instance_of Cracker, @cracker
    assert_instance_of Cracker, @cracker_default_date
  end

  def test_it_has_readable_attributes
    assert_equal "vjqtbeaweqihssi", @cracker.message
    assert_equal "vjqtbeaweqihssi", @cracker_default_date.message
    assert_equal "291018", @cracker.date
    assert_equal "291018", @cracker_default_date.date
  end



  def test_crack_key
    assert_equal "08304", @@cracker.crack_key("vjqtbeaweqihssi","291018")

    Date.stubs(:today).returns(Date.new(2018, 10, 29))
    assert_equal "08304", @@cracker.crack_key("vjqtbeaweqihssi", nil)
  end
end
