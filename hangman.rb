require 'json'
require 'date'
require 'fileutils'
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

  def update_display(guess)
    if @target.count(guess) == 1
      @display[@target.index(guess)] = guess
    else
      @target.chars.each_with_index  do |ch, idx|
        @display[idx] = guess if ch.eql?(guess)
      end
    end
  end

  def check_and_replace(guess)
    if @target.include?(guess)
      update_display(guess)
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
    puts Rainbow('Well Done! Correct guess!').crimson unless @display.include?('*')
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
      elsif guess.eql?('0')
        load_game
      else
        check_and_replace(guess)
      end
    end
    puts ''
  end

  def save_game
    FileUtils.mkdir_p('save_data')
    data_to_write = to_json
    file_path = "save_data/sf_#{Date.today.year}#{Date.today.month}#{Date.today.day}#{Time.now.hour}#{Time.now.min}#{Time.now.sec}.json"
    File.open(file_path, 'a') do |f|
      f.puts(data_to_write)
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

  def load_json(file_name)
    data = JSON.parse(File.read(file_name))
    @target = data['target']
    @display = data['display']
    @rounds = data['rounds']
    @guesses = data['guesses']
  end

  def load_game
    # check if save_game and save files exist
    return false unless Dir.exist?('save_data') && !Dir.empty?('save_data')

    Dir.entries('save_data').each do |file|
      puts Rainbow(file.to_s).peachpuff if file.end_with?('.json')
    end
    puts 'Enter the number in the file name : '
    user_input = gets.chomp
    if Dir.children('save_data').include?("sf_#{user_input}.json")
      load_json("save_data/sf_#{user_input}.json")
      run
    else
      print 'Invalid input'
    end
    # load file data and resume game
  end
end

game = HangmanGame.new
puts Rainbow('Starting a new game').turquoise
puts Rainbow('Press 1 to save game').goldenrod
puts Rainbow('Press 0 to load game').goldenrod
game.run
