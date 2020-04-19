require "./lib/enigma"
input = {
  message_file: ARGV[0],
  encrypted_file: ARGV[1]
}

message = File.open("./lib/#{input[:message_file]}", "r").read
encrypted_file = File.open("./lib/#{input[:encrypted_file]}", "w")
enigma = Enigma.new

enigma_output = enigma.encrypt(message)
encrypted_file.write(enigma_output[:encryption])

puts "Created '#{input[:encrypted_file]}' with the key #{enigma_output[:key]} and date #{enigma_output[:date]}"
