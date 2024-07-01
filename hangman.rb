require 'json'
require 'date'
require 'rainbow/refinement'
using Rainbow

class HangmanGame
  attr_reader :display, :target, :rounds

  def initialize
    contents = File.readlines('google-10000-english-no-swears.txt')
    words = contents.filter { |word| word.length.between?(6, 13) }
    @target = words.sample.chop
    @game_over = false
    @display = ''
    @rounds = 7
    @guesses = []
    @target.size.times do
      @display += '*'
    end
  end

  def check_and_replace(guess)
    if @target.include?(guess)
      if @target.count(guess) == 1
        @display[@target.index(guess)] = guess
      else
        @target.chars.each_with_index  do |ch, idx|
          @display[idx] = guess if ch.eql?(guess)
        end
      end
      player_won?
    elsif @guesses.include?(guess)
      puts Rainbow("You already guessed #{guess}.").fuchsia
    else
      @rounds -= 1
      @guesses << guess
      player_lost?
    end
    print "#{Rainbow(@display.to_s).lawngreen}\t" unless @game_over
  end

  def player_won?
    puts Rainbow('Well Done! You won!').crimson unless @display.include?('*')
  end

  def player_lost?
    return false if @rounds.positive?

    puts Rainbow('Better luck next time!').palevioletred
    puts "The word was : #{Rainbow(@target.to_s).sienna}"
    @game_over = true
  end

  def run
    print "#{@display}\t"
    while @rounds.positive? && display.include?('*')
      # puts @target
      puts "#{@rounds} ".yellow + Rainbow(@guesses.to_s).fuchsia
      print 'Guess a letter : '
      guess = gets.chomp.downcase
      if guess.eql?('1')
        save_game
        break
      else
        check_and_replace(guess)
      end
    end
    puts ''
  end

  def save_game
    FileUtils.mkdir_p('save_data')
    data_to_write = to_json
    file_path = "save_data/sf_#{Date.today.year}#{Date.today.month}#{Date.today.day}.json"
    File.open(file_path, 'a') do |f|
      f.write(data_to_write)
      f.close
    end
    puts Rainbow('Game Saved!').goldenrod
  end

  def to_json(*_args)
    JSON.dump({
                target: @target,
                display: @display,
                rounds: @rounds,
                guesses: @guesses
              })
  end
end

game = HangmanGame.new
puts Rainbow('Starting a new game').turquoise
puts Rainbow('Press 1 to save game').goldenrod
puts Rainbow('Press 0 to load game').goldenrod
game.run
