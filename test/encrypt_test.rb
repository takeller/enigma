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
    assert_equal "02715", @encryptor.key
    assert_equal "040895", @encryptor.date

    assert_equal "hello world", @encryptor_defaults.message
    assert_nil @encryptor_defaults.key
    assert_nil @encryptor_defaults.date
  end

  def test_encrypt_message
    # keys a: 02, b: 27, c: 71, d: 15 || offsets a: 1, b: 0, c: 2, d: 5
    # Final shifts -> a: 3, b: 27, c: 73, d: 20
    # Given "hello world" expected "keder ohuluw"
    keys = {
      a_key: [0,2],
      b_key: [2,7],
      c_key: [7,1],
      d_key: [1,5]
    }
    offsets = {
      a_offset: 1,
      b_offset: 0,
      c_offset: 2,
      d_offset: 5
    }
    @encryptor.stubs(:generate_keys).returns(keys)
    @encryptor.stubs(:generate_offsets).returns(offsets)

    assert_equal "keder ohulw", @encryptor.encrypt_message

    assert_equal "keder ohulw", @encryptor.encrypt_message

    @encryptor_defaults.stubs(:generate_keys).returns(keys)
    @encryptor_defaults.stubs(:generate_offsets).returns(offsets)

    assert_equal "keder ohulw", @encryptor_defaults.encrypt_message

    assert_equal "keder ohulw", @encryptor_defaults.encrypt_message
  end
end
