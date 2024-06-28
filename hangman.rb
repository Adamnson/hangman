contents = File.readlines('google-10000-english-no-swears.txt')

words = contents.filter { |word| word.length.between?(6,13)}

target = words.sample.chop    # chop the trailing "\n"
display = ""

class HangmanGame 
  attr_reader :display, :target

  def initialize
    contents = File.readlines('google-10000-english-no-swears.txt')
    words = contents.filter { |word| word.length.between?(6,13)}
    @target = words.sample.chop
    @display = "" 
    @target.size.times do
      @display += "*"
    end
  end # initialize

  def check_and_replace(guess)
    if @target.include?(guess)
      if @target.count(guess) == 1
        @display[@target.index(guess)] = guess  
      else
        @target.chars.each_with_index  do |ch, idx|
          if ch.eql?(guess)
            @display[idx] = guess
          end
        end
      end
    end
  end # check_and_replace

end #class HangmanGame


game = HangmanGame.new

puts game.target

puts game.display
print "\nGuess a letter : "
guess = gets.chomp
print "You inputs #{guess}\n"
game.check_and_replace(guess)
puts game.display

