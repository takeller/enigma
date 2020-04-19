require "./lib/enigma"

input = {
  message_file: ARGV[0],
  encrypted_file: ARGV[1]
}
# require 'pry'; binding.pry
message = File.open("./lib/#{input[:message_file]}", "r").read
encrypted_file = File.open("#{input[:encrypted_file]}", "w")
enigma = Enigma.new

enigma_output = enigma.encrypt(message)

encrypted_file.write(enigma_output[:encryption])

puts "Created '#{input[:message_file]}' with the key #{enigma_output[:key]} and date #{enigma_output[:date]}"

# $ ruby ./lib/encrypt.rb message.txt encrypted.txt
# Created 'encrypted.txt' with the key 82648 and date 240818
