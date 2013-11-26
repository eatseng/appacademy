class Board

	attr_reader :wordPanel, :guessPanel, :numberGuesses

	def initialize(numberGuesses)
		@wordPanel = String.new
		@guessPanel = []
		@numberGuesses = numberGuesses
	end

	def setWord(length)
		@wordPanel = "_" * length
	end

	def updatePanels(guessed_letter, guessed_position)
		@numberGuesses -= 1
		@guessPanel << guessed_letter
		return if guessed_position.length == 0
		
		guessed_position.each do |i|
			@wordPanel[i.to_i] = guessed_letter
		end
		@numberGuesses += 1
		@guessPanel.pop
	end

	def win?
		!@wordPanel.include?("_")
	end
	
	def lose?
		@numberGuesses == 0
	end
end



class Hangman

	def initialize(p1, p2)
		@guesser = p1
		@wordKeeper = p2
		@numberGuesses = 10
	end

	def run
		board = Board.new(@numberGuesses)
		board.setWord(@wordKeeper.pickWord)
		
		until board.lose?
			p "Correct Guesses"
			p board.wordPanel.split("")
			p "Incorrect Guesses"
			p board.guessPanel
			p "#{board.numberGuesses} Guesses Remaining"
			guessed_letter = @guesser.getGuess(board.wordPanel, board.guessPanel)
			guessed_position = @wordKeeper.getCorrectLetter(board.wordPanel, guessed_letter)
			board.updatePanels(guessed_letter, guessed_position)
			break if board.win?
		end

		if board.win?
			p "Guesser Won!!"
		else
			p "Guesser Lost!!"
		end
	end
end



class HumanPlayer
	def initialize()
	end

	def pickWord
		puts "Input length of the word"
		gets.chomp.to_i
	end

	def getGuess(wordPanel, guessPanel)
		input = ""
		loop do
			puts "Input Guessed Letter"
			input = gets.chomp
			break unless (wordPanel.include?(input) || guessPanel.include?(input))
			puts "Letter has already been guessed"
		end
		input
	end

	def getCorrectLetter(wordPanel, guessed_letter)
		puts "Guesser guessed '#{guessed_letter}'"
		input_array = []
		loop do
			puts "Input correct letter position (i.e. 0...word.length - 1.) Enter q to quit"
			input = gets.chomp
			break if input == "q"
			#p wordPanel[input.to_i]
			p "Position already selected, please re-enter position" if wordPanel[input.to_i] != "_" \
				|| input_array.include?(input)
			input_array << input if wordPanel[input.to_i] == "_" || input_array.include?(input)
		end
		input_array
	end
end



class ComputerPlayer
	def initialize()
		@word = String.new
	end

	def pickWord
		list_of_words = File.readlines("dictionary.txt").map(&:chomp)
		@word = list_of_words.sample
		@word.length
	end

	def getGuess(wordPanel, guessPanel)
		list_of_words = File.readlines("dictionary.txt").map(&:chomp)
		words_in_length = filterLength(list_of_words, wordPanel)
		words_in_position = matchCharPos(words_in_length, wordPanel)
		findMaxFreqChar(words_in_position, (guessPanel.join + wordPanel))
	end

	def getCorrectLetter(wordPanel, guessed_letter)
		#p @word
		input_array = []
		@word.split("").each_with_index do |char, i|
			input_array << i if @word[i] == guessed_letter
		end
		input_array
	end

	def filterLength(list_of_words, wordPanel)
		words = list_of_words.select {|word| word.length == wordPanel.length}
	end

	def matchCharPos(list_of_words, wordPanel)
		matched_words = []

		pos = []
		wordPanel.split("").each_with_index do |char, i|
			pos << i unless char == "_"
		end

		list_of_words.each do |word|
			matched_words << word if pos.all? { |i|
				word[i] == wordPanel[i] }
		end

		matched_words
	end

	def findMaxFreqChar(list_of_words, used_words = nil)
		freq = Hash.new(0)
		list_of_words.each do |word|
			word.split("").each do |char|
				freq[char] += 1 unless used_words.include?(char)
			end
		end

		return (rand(26)+97).chr if freq.empty?
		freq.max_by {|k, v| v}.first
	end
end

cp = ComputerPlayer.new()
cp1 = ComputerPlayer.new()
hp = HumanPlayer.new()
hp1 = HumanPlayer.new()

Hangman.new(hp, cp).run



