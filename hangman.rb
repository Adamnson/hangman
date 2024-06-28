class HangmanGame 
  attr_reader :display, :target, :rounds

  def initialize
    contents = File.readlines('google-10000-english-no-swears.txt')
    words = contents.filter { |word| word.length.between?(6,13)}
    @target = words.sample.chop
    @display = "" 
    @rounds = 7
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
    end
  end # check_and_replace

  def run
    print @display + "\t"
    while @rounds > 0 && display.include?("*")
      # puts @target
      puts @rounds
      print "Guess a letter : "
      guess = gets.chomp
      print "You inputs #{guess}\n"
      check_and_replace(guess)
      print @display + "\t"
    end
    puts ""
  end

end #class HangmanGame


game = HangmanGame.new

game.run



