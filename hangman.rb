require 'rainbow/refinement'
using Rainbow

class HangmanGame 
  attr_reader :display, :target, :rounds

  def initialize
    contents = File.readlines('google-10000-english-no-swears.txt')
    words = contents.filter { |word| word.length.between?(6,13)}
    @target = words.sample.chop
    @display = "" 
    @rounds = 7
    @guesses = []
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
    else
      @rounds -= 1
      @guesses << guess
    end
  end # check_and_replace

  def run
    print @display + "\t"
    while @rounds > 0 && display.include?("*")
      # puts @target
      puts "#{@rounds} ".yellow + Rainbow("#{@guesses}").fuchsia
      print "Guess a letter : "
      guess = gets.chomp
      check_and_replace(guess)
      print Rainbow("#{@display}").lawngreen + "\t"
    end
    puts ""
  end # run

end #class HangmanGame


game = HangmanGame.new
puts Rainbow("Starting a new game").turquoise
game.run



