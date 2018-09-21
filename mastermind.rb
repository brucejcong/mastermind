class Mastermind

	@@code_colors = ["red", "yellow", "purple", "blue", "green", "orange"]

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
			puts "Guess the code. What you got?"
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
			guess = gets.chomp.downcase
			
			guess
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
			puts "Here what you got right and wrong."
		end


	end

end

game = Mastermind.new()