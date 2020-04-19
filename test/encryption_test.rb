require './test/test_helper'
require './lib/encryption'

class EncryptionTest < MiniTest::Test

  def setup
    @encryptor = Encryption.new("hello world", "02715", "040895")
    @encryptor_defaults = Encryption.new("hello world")
  end

  def test_it_exists
    assert_instance_of Encryption, @encryptor
    assert_instance_of Encryption, @encryptor_defaults
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

  def test_format_encryption_input
    expected =
    {
      shifts:  {
        a_shift: 3,
        b_shift: 27,
        c_shift: 73,
        d_shift: 20
      },
      formated_message: [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    }
    expected_attributes = {
      encryption: "hello world",
      key: "02715",
      date: "040895"
    }
    keys = {
      a_key: [0,2],
      b_key: [2,7],
      c_key: [7,1],
      d_key: [1,5]
    }

    assert_equal expected, @encryptor.format_encryption_input
    assert_equal expected_attributes[:encryption], @encryptor.message
    assert_equal expected_attributes[:key], @encryptor.encryption_key
    assert_equal expected_attributes[:date], @encryptor.date

    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    @encryptor_defaults.stubs(:random_number_generator).returns("2715")
    assert_equal expected, @encryptor_defaults.format_encryption_input
    assert_equal expected_attributes[:encryption], @encryptor_defaults.message
    assert_equal expected_attributes[:key], @encryptor_defaults.encryption_key

    assert_equal expected_attributes[:date], @encryptor_defaults.date
  end

  def test_shift_message
    message = [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    shifts = {
      a_shift: 3,
      b_shift: 27,
      c_shift: 73,
      d_shift: 20
    }
    expected = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected, @decryptor.shift_message(message, shifts)

    Date.stubs(:today).returns(Date.new(1995, 8, 4))
    assert_equal expected, @decryptor_defaults.shift_message(message, shifts)
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
