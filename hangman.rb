require 'json'
require 'date'
require 'fileutils'
require 'rainbow/refinement'
using Rainbow

#  name: HangmanGame
#  class variables:
#   @target   : the actual word that needs to be guesses
#   @display  : the string that gets displayed to the user
#   @rounds   : variable to track the number of guesses
#   @guesses  : array to collect the wrong guesses made by the player
#   @game_over: flag to inidcate that all guesses have been exhausted
class HangmanGame # rubocop:disable Metrics/ClassLength
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

  def update_scores(guess)
    @rounds -= 1
    @guesses << guess
  end

  def check_and_replace(guess)
    if @target.include?(guess)
      update_display(guess)
      player_won?
    elsif @guesses.include?(guess)
      puts Rainbow("You already guessed #{guess}.").fuchsia
    else
      update_scores(guess)
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

  def run # rubocop:disable Metrics/MethodLength
    while @rounds.positive? && display.include?('*')
      guess = display_and_collect_input
      case guess
      when '1'
        save_game
        break
      when '0'
        load_game
      else
        check_and_replace(guess)
      end
    end
    puts ''
  end

  def display_and_collect_input
    print "#{@display}\t"
    puts "#{@rounds} ".yellow + Rainbow(@guesses.to_s).fuchsia
    print 'Guess a letter : '
    gets.chomp.downcase
  end

  def save_game
    FileUtils.mkdir_p('save_data')
    data_to_write = to_json
    d = DateTime.now
    file_path = "save_data/sf_#{d.strftime('%Y%jT%H%MZ%S')}.json"
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

  def valid_save_file_exists
    Dir.exist?('save_data') && !Dir.empty?('save_data')
  end

  def display_save_files_and_collect_json
    Dir.entries('save_data').each_with_index do |file, idx|
      puts "#{idx}) #{Rainbow(file.to_s).peachpuff}" if file.end_with?('.json')
    end
    puts 'Enter your choice '
    gets.chomp.to_i
  end

  def load_game
    return false unless valid_save_file_exists?

    user_input = display_save_files_and_collect_json
    load_json("save_data/#{Dir.children('save_data')[user_input]}") if user_input < Dir.children('save_data').size
    run
  end
end

game = HangmanGame.new
puts Rainbow('Starting a new game').turquoise
puts Rainbow('Press 1 to save game').goldenrod
puts Rainbow('Press 0 to load game').goldenrod
game.run
