require './lib/encryption_algorithm'

class Encrypt < EncryptionAlgorithm


  def encrypt_message(message, key = nil, date = nil)
    keys = generate_keys if key == nil
    offsets = generate_offsets if date == nil
    keys = format_keys(key) if key != nil
    offsets = format_offsets(date) if date != nil

    alphabet = generate_alphabet
    final_shifts = calculate_shifts(keys, offsets)
    formated_message = format_message(message)
    shifted_message = formated_message.map do |message_chunk|
      shift_chunk(message_chunk, final_shifts, alphabet, :encrypt)
    end
    shifted_message.flatten.join()
  end

end
