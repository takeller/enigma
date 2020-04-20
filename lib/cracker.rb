require './lib/encryption_algorithm'

class Cracker < EncryptionAlgorithm

  def initialize
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

end
