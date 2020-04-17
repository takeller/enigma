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
end
