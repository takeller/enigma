require "./lib/enigma"
input = {
  encrypted_file: ARGV[0],
  decrypted_file: ARGV[1],
  encryption_key: ARGV[2],
  encryption_date: ARGV[3]
}

encrypted_message = File.open("./lib/#{input[:encrypted_file]}", "r").read
decrypted_file = File.open("./lib/#{input[:decrypted_file]}", "w")
enigma = Enigma.new

enigma_output = enigma.decrypt(encrypted_message, input[:encryption_key], input[:encryption_date])
decrypted_file.write(enigma_output[:decryption])

puts "Created '#{input[:decrypted_file]}' with the key #{enigma_output[:key]} and date #{enigma_output[:date]}"
