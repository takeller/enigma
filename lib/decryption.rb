require './lib/encryption_algorithm'

class Decryption < EncryptionAlgorithm


  def decrypt_message
    # offsets = generate_offsets if @date == nil
    # offsets = format_offsets(date) if @date != nil
    # keys = format_keys(@encryption_key)
    #
    # final_shifts = calculate_shifts(keys, offsets)
    # formated_message = format_message(@message)
    formated_input = format_decryption_input
    shifted_message = formated_input[:formated_message].map do |message_chunk|
      shift_chunk(message_chunk, formated_input[:shifts], :decrypt)
    end
    @message = shifted_message.flatten.join()
    format_decryption_return
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


  def format_decryption_return
    {
      decryption: @message,
      key: @encryption_key,
      date: @date
    }
  end
end
