require './lib/encryption_algorithm'

class Cracker < EncryptionAlgorithm

  attr_reader :alphabet
  def initialize
    super(alphabet)
  end

  def crack_key(message, date = nil)
    date = Date::today.strftime("%d%m%y") if date == nil
    offsets = format_offsets(date)

    last_chunk_length = message.length % 4
    last_four_characters = {
      encrypted_chars: message[-4..-1].split(""),
      decrypted_chars: [" ", "e", "n", "d"]
    }
    find_key(last_four_characters, last_chunk_length, offsets)
  end

  def find_key(last_four_characters, last_chunk_length, offsets)
    last_four_characters_rotated = rotate_last_four_characters(last_four_characters, last_chunk_length)
    encrypted_indices = find_encrypted_indices(last_four_characters_rotated[:encrypted_chars])
    decrypted_indices = find_decrypted_indices(last_four_characters_rotated[:decrypted_chars])
    base_shifts = find_base_shifts(encrypted_indices, decrypted_indices)
    possible_shifts = find_possible_shifts(base_shifts)
    possible_keys = find_possible_keys(possible_shifts, offsets)
    find_solution_key(possible_keys)
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

  def find_possible_shifts(base_shifts)
    possible_shifts = base_shifts.transform_values do |shift|
      possible_shifts = []
      until possible_shifts.length == 5
        possible_shifts << shift
        shift += 27
      end
      possible_shifts.find_all {|shift| shift >= 0 && shift.to_s.length < 3}
    end
  end

  def find_possible_keys(possible_shifts, offsets)
    possible_shifts.map do |letter, shifts|
      keys = shifts.map do |shift|
        key = (shift - offsets[(letter.to_s + "_offset").to_sym]).to_s
        key = "0" + key if key.length == 1
        key
      end
      [letter, keys]
    end.to_h
  end

  def find_solution_key(possible_keys)
    solution_key = nil
    possible_keys[:a].each do |a_key|
      b_key = possible_keys[:b].find { |b_key| a_key[1] == b_key[0] }
      next if b_key == nil
      c_key = possible_keys[:c].find { |c_key| b_key[1] == c_key[0] }
      next if c_key == nil
      d_key = possible_keys[:d].find { |d_key| c_key[1] == d_key[0] }
      if d_key != nil
        solution_key = a_key + b_key[1] + c_key[1] + d_key[1]
      end
    end
    solution_key
  end

end
