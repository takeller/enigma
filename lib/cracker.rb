require './lib/encryption_algorithm'
class Cracker < EncryptionAlgorithm

  attr_reader :message, :date
  def initialize(message, date = nil)
    @message = message
    @date = date
    @date = Date::today.strftime("%d%m%y") if @date == nil
    @alphabet = ("a".."z").to_a << " "
  end
end
