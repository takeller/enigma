require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/encrypt'

class EncryptTest < MiniTest::Test

  def setup
    @encryptor = Encrypt.new("hello world", "02715", "040895")
    @encryptor_defaults = Encrypt.new("hello world")
  end

  def test_it_exists
    assert_instance_of Encrypt, @encryptor
    assert_instance_of Encrypt, @encryptor_defaults
  end

  def test_it_has_readable_attributes
    assert_equal "hello world", @encryptor.message
    assert_equal "02715", @encryptor.encryption_key
    assert_equal "040895", @encryptor.date

    assert_equal "hello world", @encryptor_defaults.message
    assert_nil @encryptor_defaults.encryption_key
    assert_nil @encryptor_defaults.date
  end

  def test_encrypt_message
    # keys a: 02, b: 27, c: 71, d: 15 || offsets a: 1, b: 0, c: 2, d: 5
    # Final shifts -> a: 3, b: 27, c: 73, d: 20
    # Given "hello world" expected "keder ohuluw"
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }

    assert_equal expected, @encryptor.encrypt_message


    @encryptor_defaults.set_key([0,2,7,1,5])
    Date.stubs(:today).returns(Date.new(1995, 8, 4))
    assert_equal expected, @encryptor_defaults.encrypt_message
  end

  def test_format_encryption_return
    expected = {
      encryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }
    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    @encryptor.encrypt_message
    assert_equal expected, @encryptor.format_encryption_return

    @encryptor_defaults.set_key([0,2,7,1,5])
    @encryptor_defaults.encrypt_message
    assert_equal expected, @encryptor_defaults.format_encryption_return
  end
end
