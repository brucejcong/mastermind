class Mastermind

	@@code_colors = {r: "Red", y: "Yellow", p: "Purple", b: "Blue", g: "Green", o: "Orange"}
	@@color_information = "Please enter 4 colors separated by comma. Here's the list of colors: \n#{@@code_colors.values.join(", ")}"

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
		if @codemaster.player != :computer
			until valid?(@codemaster.answer)
				puts "Please enter a valid code. Example: 'Blue, Green, Purple, Yellow'."
				@codemaster.create_code
			end
		end

		#Have codebreaker try to guess the code within 12 turns.
		until @turns == 0 
			puts "You have #{@turns} turns to guess the code. "
			puts @@color_information if @codebreaker.player != :computer
			guess = @codebreaker.guess

			if @codebreaker.player != :computer
				until valid?(guess)
					puts "Please enter a valid guess. Example: 'Blue, Green, Purple, Yellow'."
				end
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
		# code = Mastermind.translate_values(code)
		# p code
		code.each do |color|
			if !@@code_colors.values.include?(color.capitalize)
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

	def self.remove_whitespace(code)
		code = code.gsub(/[\s,]/ ,"")
		code
	end

	def self.translate_values(code)
		if Mastermind.remove_whitespace(code).length == 4
			code = Mastermind.remove_whitespace(code).chars
			code = code.map do |color|
				@@code_colors[color.downcase.to_sym]
			end
		else
			code = code.split(/\s*,\s*/)
		end
		code
	end

	class Codebreaker
		attr_reader :player
		def initialize(player, code_colors)
			@player = player
			@code_colors = code_colors.values
			if player == :computer
				@previous_guess = nil
				create_possible_codes_list
			end
		end
	
	 	def guess
			if player != :computer
				# guess = ets.chomp.split(/\s*,\s*/)
				guess = gets.chomp
				guess = Mastermind.translate_values(guess)
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

	end

	class Codemaster 
		attr_reader :answer, :player
		def initialize(player, code_colors)
			@answer = Array.new()
			@player = player
			@code_colors = code_colors.values
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
				# code = gets.chomp.split(/\s*,\s*/).map(&:capitalize)
				code = gets.chomp
				@answer = Mastermind.translate_values(code)
			end
		end

	end

end

game = Mastermind.new()