require './lib/encryption'
require './lib/decryption'
require './lib/cracker'
require './lib/encryption_algorithm'

class Enigma < EncryptionAlgorithm

  def initialize
    super(alphabet)
  end

  def encrypt(message, key = nil, date = nil)
    encryptor = Encryption.new(message, key, date)
    encryptor.encrypt_message
  end

  def decrypt(message, key, date = nil)
    decryptor = Decryption.new(message, key, date)
    decryptor.decrypt_message
  end

  def crack(message, date = nil)
    cracker = Cracker.new
    cipher_key = cracker.crack_key(message, date)
    decrypt(message, cipher_key, date)
  end
end
