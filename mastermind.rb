class Mastermind

	@@code_colors = ["Red", "Yellow", "Purple", "Blue", "Green", "Orange"]
	@@color_information = "Please enter 4 colors separated by comma. Here's the list of colors: \n#{@@code_colors.join(", ")}"

	def initialize
		@turns = 12
		@winner = nil
		play
	end

	def play
		puts "Yo, what's your name?"
		player = gets.chomp

		#Set roles for player and computer. 
		puts "Would you like to be codemaster. Yes or no?"
		if gets.chomp.downcase.include?("yes")
			@codemaster = Codemaster.new(player, @@code_colors)
			@codebreaker = Codebreaker.new(:computer, @@code_colors)
		else
			@codebreaker = Codebreaker.new(player, @@code_colors)
			@codemaster = Codemaster.new(:computer, @@code_colors)
		end

		#Have codemaster create the code. 
		puts "Codemaster, please enter your code."
		puts @@color_information if @codemaster.player != :computer
		@codemaster.create_code
		until valid?(@codemaster.answer)
			puts "Please enter a valid code. Example: 'Blue, Green, Purple, Yellow'."
			@codemaster.create_code
		end

		#Have codebreaker try to guess the code within 12 turns.
		until @turns == 0 
			puts "You have #{@turns} turns to guess the code. "
			puts @@color_information if @codebreaker.player != :computer
			guess = @codebreaker.guess
			until valid?(guess)
				puts "Please enter a valid guess. Example: 'Blue, Green, Purple, Yellow'."
				guess = @codebreaker.guess
			end
			puts "Codebreaker guesses: #{guess.join(", ")}"

			#Codemaster checks whether the guessed code is right and gives feedback. 
			feedback = Mastermind.check_guess(guess, @codemaster.answer)
			if feedback[0] != 4
				@turns -= 1
				if @codebreaker.player == :computer
					@codebreaker.pass_info(feedback)
				end
				puts "#{feedback[0]} correct guesses and #{feedback[1]} correct colors."
			else
				@turns = 0
				@winner = @codebreaker
			end
		end

		#Declare winner
		@winner = @codemaster if @winner.nil?
		puts "#{@winner.player.capitalize} wins!"
	end


	def valid?(code)
		return false if code.length != 4
		code.each do |color|
			if !@@code_colors.include?(color.capitalize)
				return false
			end
		end
		return true
	end

	def self.check_guess(guess, answer)
		color_counts = Hash.new(0)

		# Item 1 = Right color and position,
		# Item 2 = Only right color
		key = Array.new(2){0}
		guess.each_with_index do |color, position|
			color_counts[color.capitalize.to_sym] += 1
			if answer.include?(color.capitalize)
				if answer[position] == color.capitalize
					key[0] += 1
					if answer.count(color.capitalize) < color_counts[color.capitalize.to_sym]
						key[1] -= 1
					end
				else
					if answer.count(color.capitalize) >= color_counts[color.capitalize.to_sym]
						key[1] += 1
					end
				end

			end
		end
		return key
	end




	# def code
	# 	puts "Please enter 4 colors separated by comma. Here's the list of colors: "
	# 	puts @@code_colors.join(", ")
	# 	guess = gets.chomp.split(/\s*,\s*/)
	# 	until valid?(guess)
	# 		puts "Please enter a valid guess. Example: 'Blue, Green, Purple, Yellow'."
	# 		guess = gets.chomp.split(/\s*,\s*/)
	# 	end
	# 	guess

	# end

	class Codebreaker
		attr_reader :player
		def initialize(player, code_colors)
			@player = player
			@code_colors = code_colors
			if player == :computer
				@previous_guess = nil
				create_possible_codes_list
			end
		end

		def guess
			if player != :computer
				guess = gets.chomp.split(/\s*,\s*/)
			else
				if !@previous_guess.nil?
					update_possible_codes_list
				end				
				guess = @possible_codes.sample
				@previous_guess = guess
			end
			guess
		end

		def pass_info(info)
			@feedback = info
		end

		def create_possible_codes_list
			@possible_codes = []
			@code_colors.each do |color1|
				@code_colors.each do |color2|
					@code_colors.each do |color3|
						@code_colors.each do |color4|
							@possible_codes << [color1, color2, color3, color4]
						end
					end
				end
			end
		end

		def update_possible_codes_list
			@possible_codes = @possible_codes.select do |code|
				Mastermind.check_guess(code, @previous_guess) == @feedback
			end
		end





		# def valid?(guess)
		# 	return false if guess.length != 4
		# 	guess.each do |color|
		# 		if !@code_colors.include?(color.capitalize)
		# 			return false
		# 		end
		# 	end
		# 	return true
		# end

	end

	class Codemaster 
		attr_reader :answer, :player
		def initialize(player, code_colors)
			@answer = Array.new()
			@player = player
			@code_colors = code_colors
			# if @player == :computer
			# 	4.times do 
			# 		@answer << code_colors[rand(6)]
			# 	end
			# end
		end

		def create_code
			if @player == :computer
				4.times do 
					@answer << @code_colors[rand(6)]
				end
			else
				code = gets.chomp.split(/\s*,\s*/).map(&:capitalize)
				@answer = code
			end
		end


		# def check_guess(guess)
		# 	color_counts = Hash.new(0)

		# 	# Item 1 = Right color and position,
		# 	# Item 2 = Only right color
		# 	key = Array.new(2){0}
		# 	guess.each_with_index do |color, position|
		# 		color_counts[color.capitalize.to_sym] += 1
		# 		if @answer.include?(color.capitalize)
		# 			if @answer[position] == color.capitalize
		# 				key[0] += 1
		# 				if @answer.count(color.capitalize) < color_counts[color.capitalize.to_sym]
		# 					key[1] -= 1
		# 				end
		# 			else
		# 				if @answer.count(color.capitalize) >= color_counts[color.capitalize.to_sym]
		# 					key[1] += 1
		# 				end
		# 			end

		# 		end
		# 	end
		# 	puts "#{key[0]} correct guesses and #{key[1]} correct colors."
		# 	return key
		# end


	end

end

game = Mastermind.new()