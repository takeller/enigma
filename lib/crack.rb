require "./lib/enigma"
input = {
  encrypted_file: ARGV[0],
  decrypted_file: ARGV[1],
  encryption_date: ARGV[2],
}

encrypted_message = File.open("./lib/#{input[:encrypted_file]}", "r").read
encrypted_message = encrypted_message.delete("\n")
decrypted_file = File.open("./lib/#{input[:decrypted_file]}", "w")
enigma = Enigma.new

enigma_output = enigma.crack(encrypted_message, input[:encryption_date])
decrypted_file.write(enigma_output[:decryption])

puts "Created '#{input[:decrypted_file]}' with the cracked key #{enigma_output[:key]} and date #{enigma_output[:date]}"
