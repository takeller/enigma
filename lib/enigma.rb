require './lib/encryption'
require './lib/decryption'
class Enigma

  def encrypt(message, key = nil, date = nil)
    encryptor = Encryption.new(message, key, date)
    encryptor.encrypt_message
  end

  def decrypt(message, key, date = nil)
    decryptor = Decryption.new(message, key, date)
    decryptor.decrypt_message
  end
end
