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
    assert_equal "02715", @encryptor_defaults.key
    assert_equal "040895", @encryptor_defaults.date
  end
end
