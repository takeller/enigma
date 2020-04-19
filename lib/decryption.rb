require './lib/encryption_algorithm'

class Decryption < EncryptionAlgorithm

  def decrypt_message
    formated_input = format_decryption_input
    decrypted_message = shift_message(formated_input[:formated_message], formated_input[:shifts])
    format_decryption_return(decrypted_message)
  end

  def format_decryption_input
    offsets = generate_offsets if @date == nil
    offsets = format_offsets(date) if @date != nil
    keys = format_keys(@encryption_key)

    final_shifts = calculate_shifts(keys, offsets)
    formated_message = format_message(@message)
    {
      shifts: final_shifts,
      formated_message: formated_message,
    }
  end

  def shift_message(message,shifts)
    message.map do |message_chunk|
      shift_chunk(message_chunk, shifts, :decrypt)
    end
  end


  def format_decryption_return(decrypted_message)
    @message = decrypted_message.flatten.join()
    {
      decryption: @message,
      key: @encryption_key,
      date: @date
    }
  end
end
