require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/encryption_algorithm'

class EncryptionAlgorithmTest < MiniTest::Test
  def setup
    @enigma_machine = EncryptionAlgorithm.new
  end

  def test_it_exists
    assert_instance_of EncryptionAlgorithm, @enigma_machine
  end

  def test_it_can_generate_keys
    # 02715
    # return hash where a-d key points to correct digits
    @enigma_machine.stubs(:random_number_generator).returns([0,2,7,1,5])
    expected = {
      a_key: [0,2],
      b_key: [2,7],
      c_key: [7,1],
      d_key: [1,5]
    }
    assert_equal expected, @enigma_machine.generate_keys
  end

  def test_random_number_generator
    random_key = @enigma_machine.random_number_generator
    assert_instance_of Array, random_key
    assert_equal 5, random_key.length
    random_key.each do |digit|
      assert_instance_of Integer, digit
    end
  end
end
