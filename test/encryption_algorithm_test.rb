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

  def test_generate_offsets
    # ddmmyy, August 4, 1995 -> 040895

    expected = {
      a_offset: 1,
      b_offset: 0,
      c_offset: 2,
      d_offset: 5
    }
    assert_equal expected, @enigma_machine.generate_offsets("040895")
  end

  def test_encrypt_message
    # keys a: 02, b: 27, c: 71, d: 15 || offsets a: 1, b: 0, c: 2, d: 5
    # Final shifts -> a: 3, b: 27, c: 73, d: 20
    # Given "hello world" expected "keder ohuluw"

    assert_equal "keder ohuluw", @enigma_machine.encrypt_message("hello world")
  end
end
