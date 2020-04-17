class EncryptionAlgorithm

  def initialize

  end

  def generate_keys
    encryption_key = []
    random_number = rand(10 ** 5).to_s
    random_number.each_char { |digit| encryption_key << digit.to_i  }
    until encryption_key.length == 5
      encryption_key.unshift(0)
    end

    keys = {
      a_key: encryption_key[0,2],
      b_key: encryption_key[1,2],
      c_key: encryption_key[2,2],
      d_key: encryption_key[3,2]
    }
  end
end
