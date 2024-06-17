contents = File.readlines('google-10000-english-no-swears.txt')

words = contents.filter { |word| word.length.between?(6,13)}

target = words.sample