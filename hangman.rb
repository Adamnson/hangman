contents = File.readlines('google-10000-english-no-swears.txt')

words = contents.filter { |word| word.length.between?(6,13)}

target = words.sample
display = ""
puts target
(target.size - 1).times do    # (-1) because the last character is \n
  display += "*"
end
puts display
puts "\nGuess a letter : "
guess = gets.chomp
print "You inputs #{guess}\n"
if target.include?(guess)    # this will replace only the first occurance
  display.g guess
end
puts display

