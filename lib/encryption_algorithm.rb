require 'date'
require 'pry'
class EncryptionAlgorithm

  attr_reader :message, :encryption_key, :date, :alphabet
  def initialize(message, encryption_key = nil, date = nil)
    @message = message
    @encryption_key = encryption_key
    @date = date
    @alphabet = ("a".."z").to_a << " "
  end

  def random_number_generator
    rand(10 ** 5).to_s
  end

  def generate_keys
    format_keys(random_number_generator)
  end

  def format_keys(key)
    key = convert_key_string_to_array(key)
    {
      a_key: key[0,2],
      b_key: key[1,2],
      c_key: key[2,2],
      d_key: key[3,2]
    }
  end

  def convert_key_string_to_array(key)
    modified_key = []
    key.each_char { |digit| modified_key << digit.to_i  }
    until modified_key.length == 5
      modified_key.unshift(0)
    end
    set_key(modified_key) if @encryption_key == nil
    modified_key
  end

  def set_key(key)
    @encryption_key = key.join()
  end

  def generate_offsets
    @date = Date::today.strftime("%d%m%y")
    format_offsets(@date)
  end

  def format_offsets(date)
    last4_digits = []
    date_squared = (date.to_i ** 2).to_s
    date_squared[-4..-1].each_char { |digit| last4_digits << digit.to_i  }

    {
      a_offset: last4_digits[0],
      b_offset: last4_digits[1],
      c_offset: last4_digits[2],
      d_offset: last4_digits[3]
    }
  end

  def calculate_shifts(keys, offsets)
    # a key + a offset
    {
      a_shift: keys[:a_key].join.to_i + offsets[:a_offset],
      b_shift: keys[:b_key].join.to_i + offsets[:b_offset],
      c_shift: keys[:c_key].join.to_i + offsets[:c_offset],
      d_shift: keys[:d_key].join.to_i + offsets[:d_offset]
    }
  end

  # Break message into chunks of 4 characters
  def format_message(message)
    chunked_message = []
    lowercase_message = message.downcase
    lowercase_message.chars.each_slice(4) do |chunk|
      chunked_message << chunk
    end
    chunked_message
  end

  # shift the 4 letter chunk
  def shift_chunk(message_chunk, shifts, encrypt_or_decrypt)
    shifts = [shifts[:a_shift], shifts[:b_shift], shifts[:c_shift], shifts[:d_shift]]
    message_chunk.map.with_index do |char, chunk_index|
      next(char) if @alphabet.include?(char) == false
      alphabet_index = @alphabet.index(char)
      if encrypt_or_decrypt == :encrypt
        new_character = @alphabet.rotate(shifts[chunk_index])[alphabet_index]
      elsif encrypt_or_decrypt == :decrypt
        new_character = @alphabet.rotate(-shifts[chunk_index])[alphabet_index]
      end
      new_character
    end
  end

end
