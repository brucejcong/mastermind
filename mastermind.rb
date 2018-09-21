class Mastermind

	@@code_colors = ["Red", "Yellow", "Purple", "Blue", "Green", "Orange"]

	def initialize
		@turns = 12
		play
	end

	def play
		puts "Yo, what's your name?"
		player_name = gets.chomp
		@codebreaker = Player.new(player_name, @@code_colors)
		@codemaster = Computer.new(@@code_colors)
		until @turns == 0
			puts "Guess the code. Please enter 4 colors separated by comma. Here's the list of colors: " 
			puts @@code_colors.join(", ")
			guess = @codebreaker.guess

			@codemaster.check_guess(guess)
			@turns -= 1
		end
	end





	class Player
		def initialize(player_name, code_colors)
			@name = player_name
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

	class Computer 
		attr_reader :answer
		def initialize(code_colors)
			@answer = Array.new()
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

		end


	end

end

game = Mastermind.new()