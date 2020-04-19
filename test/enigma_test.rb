require './test/test_helper'
require './lib/encryption_algorithm'
require './lib/enigma'

class EnigmaTest < MiniTest::Test

  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_can_encrypt_a_message
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    keys = {
      a_key: [0,2],
      b_key: [2,7],
      c_key: [7,1],
      d_key: [1,5]
    }
    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    assert_equal expected, @enigma.encrypt("hello world", "02715", "040895")
    assert_equal expected, @enigma.encrypt("hello world", "02715")

    Encryption.any_instance.stubs(:generate_keys).returns(keys)
    Encryption.any_instance.stubs(:encryption_key).returns("02715")
    assert_equal expected, @enigma.encrypt("hello world")
  end

  def test_it_can_decrypt_a_message
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
    }
    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    assert_equal expected, @enigma.decrypt("keder ohulw", "02715", "040895")

    assert_equal expected, @enigma.decrypt("keder ohulw", "02715")
  end

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
end
