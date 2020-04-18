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
    @enigma_machine.stubs(:random_number_generator).returns("02715")
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
    assert_instance_of String, random_key
  end

  def test_generate_offsets
    # ddmmyy, August 4, 1995 -> 040895
    Date.stubs(:today).returns(Date.new(1995, 8, 4))
    expected = {
      a_offset: 1,
      b_offset: 0,
      c_offset: 2,
      d_offset: 5
    }
    assert_equal expected, @enigma_machine.generate_offsets
  end

  def test_calculate_shifts
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
    expected = {
      a_shift: 3,
      b_shift: 27,
      c_shift: 73,
      d_shift: 20
    }
    @enigma_machine.stubs(:generate_keys).returns(keys)
    @enigma_machine.stubs(:generate_offsets).returns(offsets)

    assert_equal expected, @enigma_machine.calculate_shifts(keys, offsets)
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
    @enigma_machine.stubs(:generate_keys).returns(keys)
    @enigma_machine.stubs(:generate_offsets).returns(offsets)

    assert_equal "keder ohulw", @enigma_machine.encrypt_message("hello world", "02715", "040895")

    assert_equal "keder ohulw", @enigma_machine.encrypt_message("hello world")
  end

  def test_decrypt_message

    Date.stubs(:today).returns(Date.new(1995, 8, 4))

    assert_equal "hello world", @enigma_machine.decrypt_message("keder ohulw", "02715", "040895")
    assert_equal "hello world", @enigma_machine.decrypt_message("keder ohulw", "02715")
  end

  def test_generate_alphabet
    expected =  ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @enigma_machine.generate_alphabet
  end

  def test_format_message
    expected = [["h", "e", "l", "l"], ["o", " ", "w", "o"], ["r", "l", "d"]]
    assert_equal expected, @enigma_machine.format_message("HeLlo WorLd")
  end

  def test_shift_chunk
    shifts = {
      a_shift: 3,
      b_shift: 27,
      c_shift: 73,
      d_shift: 20
    }
    alphabet = ("a".."z").to_a << " "

    assert_equal ["k", "e", "d", "e"], @enigma_machine.shift_chunk(["h", "e", "l", "l"], shifts, alphabet)
    assert_equal ["r", " ", "o", "h"], @enigma_machine.shift_chunk(["o", " ", "w", "o"], shifts, alphabet)
  end

  def test_format_keys
    expected = {
      a_key: [0,2],
      b_key: [2,7],
      c_key: [7,1],
      d_key: [1,5]
    }

    assert_equal expected, @enigma_machine.format_keys("02715")
  end

  def test_format_offsets
    expected = {
      a_offset: 1,
      b_offset: 0,
      c_offset: 2,
      d_offset: 5
    }
    assert_equal expected, @enigma_machine.format_offsets("040895")
  end

  def test_convert_key_string_to_array
    expected = [0,2,7,1,5]
    assert_equal expected, @enigma_machine.convert_key_string_to_array("02715")
  end

end
