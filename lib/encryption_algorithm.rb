require 'date'
require 'pry'
class EncryptionAlgorithm

  def initialize

  end

  def random_number_generator
    encryption_key = []
    random_number = rand(10 ** 5).to_s
    random_number.each_char { |digit| encryption_key << digit.to_i  }
    until encryption_key.length == 5
      encryption_key.unshift(0)
    end
    encryption_key
  end

  def generate_keys(key = nil)
    encryption_key = random_number_generator
    {
      a_key: encryption_key[0,2],
      b_key: encryption_key[1,2],
      c_key: encryption_key[2,2],
      d_key: encryption_key[3,2]
    }
  end

  def format_keys(key)
    encryption_key = []
    key.each_char { |digit| encryption_key << digit.to_i  }
    until encryption_key.length == 5
      encryption_key.unshift(0)
    end
    {
      a_key: encryption_key[0,2],
      b_key: encryption_key[1,2],
      c_key: encryption_key[2,2],
      d_key: encryption_key[3,2]
    }
  end

  def convert_key_string_to_array(key)
    encryption_key = []
    key.each_char { |digit| encryption_key << digit.to_i  }
    until encryption_key.length == 5
      encryption_key.unshift(0)
    end
    encryption_key
  end

  def generate_offsets(date = Date::today.strftime("%d%m%y"))
    last4_digits = []
    date_squared = (date.to_i ** 2).to_s
    date_squared[-4..-1].each_char { |digit| last4_digits << digit.to_i  }

    offsets = {
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
  def shift_chunk(message_chunk, shifts, alphabet)
    shifts = [shifts[:a_shift], shifts[:b_shift], shifts[:c_shift], shifts[:d_shift]]
    message_chunk.map.with_index do |char, chunk_index|
      alphabet_index = alphabet.index(char)
      new_character = alphabet.rotate(shifts[chunk_index])[alphabet_index]
      message_chunk[chunk_index] = new_character
    end
  end

  # def encrypt_message(message, keys = nil, offsets = nil)
  #   keys = generate_keys if keys == nil
  #   offsets = generate_offsets if offsets == nil
  #   keys = format_keys if keys != nil
  #   offsets = format_offsets if offsets != nil
  #
  #   alphabet = generate_alphabet
  #   final_shifts = calculate_shifts(keys, offsets)
  #   formated_message = format_message(message)
  #   shifted_message = formated_message.map do |message_chunk|
  #     shift_chunk(message_chunk, final_shifts, alphabet)
  #   end
  #   encrypted_message = shifted_message.flatten.join()
  # end

  def generate_alphabet
    ("a".."z").to_a << " "
  end
end
