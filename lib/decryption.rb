require './lib/encryption_algorithm'

class Decryption < EncryptionAlgorithm


  def decrypt_message
    offsets = generate_offsets if @date == nil
    offsets = format_offsets(date) if @date != nil
    keys = format_keys(@encryption_key)

    final_shifts = calculate_shifts(keys, offsets)
    formated_message = format_message(@message)
    shifted_message = formated_message.map do |message_chunk|
      shift_chunk(message_chunk, final_shifts, :decrypt)
    end
    @message = shifted_message.flatten.join()
    format_decryption_return
  end

  def format_decryption_return
    {
      decryption: @message,
      key: @encryption_key,
      date: @date
    }
  end

end
