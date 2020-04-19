require './lib/encryption_algorithm'

class Encryption < EncryptionAlgorithm


  def encrypt_message
    # keys = generate_keys if @encryption_key == nil
    # offsets = generate_offsets if @date == nil
    # keys = format_keys(@encryption_key) if @encryption_key != nil
    # offsets = format_offsets(date) if @date != nil
    #
    # final_shifts = calculate_shifts(keys, offsets)
    # formated_message = format_message(@message)
    formated_input = format_encryption_input
    shifted_message = formated_message.map do |message_chunk|
      shift_chunk(message_chunk, final_shifts, :encrypt)
    end
    @message = shifted_message.flatten.join()
    format_encryption_return
  end

  def format_encryption_input
    keys = generate_keys if @encryption_key == nil
    offsets = generate_offsets if @date == nil
    keys = format_keys(@encryption_key) if @encryption_key != nil
    offsets = format_offsets(date) if @date != nil

    final_shifts = calculate_shifts(keys, offsets)
    formated_message = format_message(@message)
    {
      shifts: final_shifts,
      formated_message: formated_message,
    }
  end

  def format_encryption_return
    {
      encryption: message,
      key: encryption_key,
      date: date
    }
  end

end
