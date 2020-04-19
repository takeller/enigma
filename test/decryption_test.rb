require './test/test_helper'
require './lib/decryption'

class DecryptionTest < MiniTest::Test

  def setup
    @decryptor = Decryption.new("keder ohulw", "02715", "040895")
    @decryptor_defaults = Decryption.new("keder ohulw", "02715")
  end

  def test_it_exists
    assert_instance_of Decryption, @decryptor
    assert_instance_of Decryption, @decryptor_defaults
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
    decrypted_message = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]

    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    @decryptor.decrypt_message
    assert_equal expected, @decryptor.format_decryption_return(decrypted_message)

    @decryptor_defaults.set_key([0,2,7,1,5])
    @decryptor_defaults.decrypt_message
    assert_equal expected, @decryptor_defaults.format_decryption_return(decrypted_message)
  end

  def test_format_decryption_input
    expected =
    {
      shifts:  {
        a_shift: 3,
        b_shift: 27,
        c_shift: 73,
        d_shift: 20
      },
      formated_message: [["k", "e", "d", "e"], ["r", " ", "o", "h"], ["u", "l", "w"]]
    }
    expected_attributes = {
      decryption: "keder ohulw",
      key: "02715",
      date: "040895"
    }

    assert_equal expected, @decryptor.format_decryption_input
    assert_equal expected_attributes[:decryption], @decryptor.message
    assert_equal expected_attributes[:key], @decryptor.encryption_key
    assert_equal expected_attributes[:date], @decryptor.date

    Date.stubs(:today).returns(Date.new(1995, 8, 4))
    assert_equal expected, @decryptor_defaults.format_decryption_input
    assert_equal expected_attributes[:decryption], @decryptor_defaults.message
    assert_equal expected_attributes[:key], @decryptor_defaults.encryption_key
    assert_equal expected_attributes[:date], @decryptor_defaults.date
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
end
