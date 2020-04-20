require './lib/encryption_algorithm'

class Cracker < EncryptionAlgorithm

  def initialize
  end

  def crack_key(message, date = nil)
    # If date == nil, use todays date
    date = Date::today.strftime("%d%m%y") if date == nil
    offsets = format_offsets(date)


    # last_chunk_size = message.length % 4
    # last_four_chars_encrypted = message[-4..-1].split("")
    # last_four_chars_decrypted = [" ", "e", "n", "d"]
    # if last_chunk_size == 3
    #   last_four_chars_encrypted = last_four_chars_encrypted.rotate(1)
    #   last_four_chars_decrypted = last_four_chars_decrypted.rotate(1)
    # elsif last_chunk_size == 2
    #   last_four_chars_encrypted = last_four_chars_encrypted.rotate(2)
    #   last_four_chars_decrypted = last_four_chars_decrypted.rotate(2)
    # elsif last_chunk_size == 1
    #   last_four_chars_encrypted = last_four_chars_encrypted.rotate(3)
    #   last_four_chars_decrypted = last_four_chars_decrypted.rotate(3)
    # end
  end

  def format_last_four_characters(characters, last_chunk_length)
    rotation_amount = 4 - last_chunk_length
    characters[:encrypted_chars] = characters[:encrypted_chars].rotate(rotation_amount)
    characters[:decrypted_chars] = characters[:decrypted_chars].rotate(rotation_amount)
    characters
  end

end
