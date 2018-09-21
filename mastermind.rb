class Mastermind

	@@code_colors = ["Red", "Yellow", "Purple", "Blue", "Green", "Orange"]

	def initialize
		@turns = 12
		@winner = nil
		play
	end

	def play
		puts "Yo, what's your name?"
		player_name = gets.chomp
		puts "Would you like to be codemaster. Yes or no?"
		if gets.chomp.downcase.include?("yes")
			@codemaster = Codemaster.new(player_name, @@code_colors)
			@codebreaker = Codebreaker.new("computer", @@code_colors)
		else
			@codebreaker = Codebreaker.new(player_name, @@code_colors)
			@codemaster = Codemaster.new("computer", @@code_colors)
		end

		until @turns == 0 
			puts "You have #{@turns} to guess the code. Please enter 4 colors separated by comma. Here's the list of colors: " 
			puts @@code_colors.join(", ")
			guess = @codebreaker.guess

			if @codemaster.check_guess(guess).nil?
				@turns -= 1
			else
				@turns = 0
				@winner = @codebreaker
			end
		end
		@winner = @codemaster if @winner.nil?
		puts "#{@winner.player_name.capitalize} wins!"
	end


	class Codebreaker
		attr_reader :player_name
		def initialize(player_name, code_colors)
			@player_name = player_name
			@code_colors = code_colors
		end

		def guess
			guess = gets.chomp.split(/\s*,\s*/)
			until valid?(guess)
				puts "Please enter a valid guess. Example: 'Blue, Green, Purple, Yellow'."
				guess = gets.chomp.split(/\s*,\s*/)
			end
			guess
		end

		def valid?(guess)
			return false if guess.length != 4
			guess.each do |color|
				if !@code_colors.include?(color.capitalize)
					return false
				end
			end
			return true
		end

	end

	class Codemaster 
		attr_reader :answer, :player_name
		def initialize(player_name, code_colors)
			@answer = Array.new()
			@player_name = player_name
			4.times do 
				@answer << code_colors[rand(6)]
			end
		end

		def check_guess(guess)
			color_counts = Hash.new(0)

			# Item 1 = Right color and position,
			# Item 2 = Only right color
			key = Array.new(2){0}
			guess.each_with_index do |color, position|
				color_counts[color.capitalize.to_sym] += 1
				if @answer.include?(color.capitalize)
					if @answer[position] == color.capitalize
						key[0] += 1
						if @answer.count(color.capitalize) < color_counts[color.capitalize.to_sym]
							key[1] -= 1
						end
					else
						if @answer.count(color.capitalize) >= color_counts[color.capitalize.to_sym]
							key[1] += 1
						end
					end

				end
			end
			puts "#{key[0]} correct guesses and #{key[1]} correct colors."
			return "I lost." if key[0] == 4

		end


	end

end

game = Mastermind.new()