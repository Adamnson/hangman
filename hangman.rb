require 'json'
require 'date'
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
      player_won?
    else
      @rounds -= 1
      @guesses << guess
      player_lost?
    end
    print Rainbow("#{@display}").lawngreen + "\t" 
  end # check_and_replace

  def player_won?
    puts Rainbow("Well Done! You won!").crimson unless @display.include?("*")
  end

  def player_lost?
    unless @rounds > 0
      puts Rainbow("Better luck next time!").palevioletred 
      puts "The word was : " + Rainbow("#{@target}").sienna 
    end
  end

  def run
    print @display + "\t"
    while @rounds > 0 && display.include?("*")
      # puts @target
      puts "#{@rounds} ".yellow + Rainbow("#{@guesses}").fuchsia
      print "Guess a letter : "
      guess = gets.chomp
      if guess.eql?("1")
        save_game
        break
      else
        check_and_replace(guess)
      end
    end
    puts ""
  end # run

  def save_game
    Dir.mkdir('save_data') unless Dir.exist?('save_data')
    data_to_write = self.to_json
    file_path = "save_data/sf_#{Date.today.year.to_s}#{Date.today.month.to_s}#{Date.today.day.to_s}.json"
    File.open(file_path, "a") do |f|
      f.write(data_to_write)
      f.close
    end
    puts Rainbow("Game Saved!").goldenrod
end
    
  def to_json
    JSON.dump ({
      :target => @target,
      :display => @display,
      :rounds => @rounds,
      :guesses => @guesses
    })
  end

end #class HangmanGame


game = HangmanGame.new
puts Rainbow("Starting a new game").turquoise
puts Rainbow("Press 1 to save game").goldenrod
puts Rainbow("Press 0 to load game").goldenrod
game.run



