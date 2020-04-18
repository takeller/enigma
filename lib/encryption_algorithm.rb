require 'date'
require 'pry'
class EncryptionAlgorithm

  def initialize

  end

  def random_number_generator
    encryption_key = []
    random_number = rand(10 ** 5).to_s
    random_number.each_char { |digit| encryption_key << digit.to_i  }
    until encryption_key.length == 5
      encryption_key.unshift(0)
    end
    encryption_key
  end

  def generate_keys
    encryption_key = random_number_generator
    {
      a_key: encryption_key[0,2],
      b_key: encryption_key[1,2],
      c_key: encryption_key[2,2],
      d_key: encryption_key[3,2]
    }
  end

  def generate_offsets(date = Date::today.strftime("%d%m%y"))
    last4_digits = []
    date_squared = (date.to_i ** 2).to_s
    date_squared[-4..-1].each_char { |digit| last4_digits << digit.to_i  }

    offsets = {
      a_offset: last4_digits[0],
      b_offset: last4_digits[1],
      c_offset: last4_digits[2],
      d_offset: last4_digits[3]
    }
  end
end
