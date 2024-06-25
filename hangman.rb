contents = File.readlines('google-10000-english-no-swears.txt')

words = contents.filter { |word| word.length.between?(6,13)}

target = words.sample.chop    # chop the trailing "\n"
display = ""

def check_and_replace(target, display, guess)
  if target.include?(guess)
    if target.count(guess) == 1
      display[target.index(guess)] = guess   # will replace only the first occurance
    else
      target.chars.each_with_index  do |ch, idx|
        if ch.eql?(guess)
          display[idx] = guess
        end
      end
    end
  end
end

puts target
target.size.times do
  display += "*"
end
puts display
print "\nGuess a letter : "
guess = gets.chomp
print "You inputs #{guess}\n"
check_and_replace(target, display, guess)
puts display

