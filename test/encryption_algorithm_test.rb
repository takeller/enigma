require 'minitest/autorun'
require 'minitest/pride'
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

    expected = {
      a_key: 02,
      b_key: 27,
      c_key: 71,
      d_key: 15
    }
    assert_equal expected, @enigma_machine.generate_keys 
  end
end
