require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/decrypt'

class DecryptTest < MiniTest::Test

  def setup
    @decryptor = Decrypt.new("keder ohulw", "02715", "040895")
    @decryptor_defaults = Decrypt.new("keder ohulw", "02715")
  end

  def test_it_exists
    assert_instance_of Decrypt, @decryptor
    assert_instance_of Decrypt, @decryptor_defaults
  end

  def test_it_has_readable_attributes
    assert_equal "keder ohulw", @decryptor.message
    assert_equal "02715", @decryptor.encryption_key
    assert_equal "040895", @decryptor.date

    assert_equal "keder ohulw", @decryptor_defaults.message
    assert_equal "02715", @decryptor_defaults.encryption_key
    assert_nil @decryptor_defaults.date
  end

  def test_decrypt_message
    # keys a: 02, b: 27, c: 71, d: 15 || offsets a: 1, b: 0, c: 2, d: 5
    # Final shifts -> a: 3, b: 27, c: 73, d: 20
    # Given "hello world" expected "keder ohuluw"
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
    }

    assert_equal expected, @decryptor.decrypt_message


    @decryptor_defaults.set_key([0,2,7,1,5])
    Date.stubs(:today).returns(Date.new(1995, 8, 4))
    assert_equal expected, @decryptor_defaults.decrypt_message
  end

  def test_format_decryption_return
    expected = {
      decryption: "hello world",
      key: "02715",
      date: "040895"
    }
    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    @decryptor.decrypt_message
    assert_equal expected, @decryptor.format_decryption_return

    @decryptor_defaults.set_key([0,2,7,1,5])
    @decryptor_defaults.decrypt_message
    assert_equal expected, @decryptor_defaults.format_decryption_return
  end
end
