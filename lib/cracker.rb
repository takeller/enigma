require './lib/encryption_algorithm'

class Cracker < EncryptionAlgorithm

  attr_reader :alphabet
  def initialize
    super(alphabet)
  end

  def crack_key(message, date = nil)
    # If date == nil, use todays date
    date = Date::today.strftime("%d%m%y") if date == nil
    offsets = format_offsets(date)

    last_chunk_length = message.length % 4
    last_four_characters = {
      encrypted_chars: message[-4..-1].split(""),
      decrypted_chars: [" ", "e", "n", "d"]
    }
    last_four_characters_rotated = rotate_last_four_characters(last_four_characters, last_chunk_length)

  end

  def rotate_last_four_characters(characters, last_chunk_length)
    rotation_amount = 4 - last_chunk_length
    characters[:encrypted_chars] = characters[:encrypted_chars].rotate(rotation_amount)
    characters[:decrypted_chars] = characters[:decrypted_chars].rotate(rotation_amount)
    characters
  end

  def find_encrypted_indices(encrypted_chars)
    {
      a: @alphabet.index(encrypted_chars[0]),
      b: @alphabet.index(encrypted_chars[1]),
      c: @alphabet.index(encrypted_chars[2]),
      d: @alphabet.index(encrypted_chars[3])
    }
  end

  def find_decrypted_indices(decrypted_chars)
    {
      a: @alphabet.index(decrypted_chars[0]),
      b: @alphabet.index(decrypted_chars[1]),
      c: @alphabet.index(decrypted_chars[2]),
      d: @alphabet.index(decrypted_chars[3])
    }
  end

  def find_base_shifts(encrypted_indices, decrypted_indices)
    {
      a: encrypted_indices[:a] - decrypted_indices[:a],
      b: encrypted_indices[:b] - decrypted_indices[:b],
      c: encrypted_indices[:c] - decrypted_indices[:c],
      d: encrypted_indices[:d] - decrypted_indices[:d]
    }
  end

end
