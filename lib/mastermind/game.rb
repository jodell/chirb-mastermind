module Mastermind
  module Constants
    COLORS        = %w(r g b c w).freeze unless defined?(COLORS)
    CODE_SIZE     = 4 unless defined?(CODE_SIZE)
    CORRECT_POS   = 'b' unless defined?(CORRECT_POS)
    CORRECT_COLOR = 'w' unless defined?(CORRECT_COLOR)
  end

  class Game
    include Constants

    attr_accessor :guesses, :code

    def initialize(messenger)
      @messenger = messenger
      @guesses = []
    end
    
    def start(secret_code = random_code)
      @code = secret_code
      #STDOUT.puts @code.inspect
      @messenger.puts "Welcome to Mastermind!"
      @messenger.puts "Enter guess:"
    end

    def random_code
      CODE_SIZE.times do 
        (@random_code ||= []) << COLORS[rand(COLORS.size)]
      end; @random_code
    end
    
    def guess(guess)
      @guesses << guess
      @messenger.puts result_pins_with(guess, code)
      @messenger.puts win_message if over?
    end

    def result_pins_with(guess = @guesses.last, code = @code)
      return CORRECT_POS * CODE_SIZE if over?(guess) # winner, winner, chicken dinner
      (0..CODE_SIZE-1).inject([]) do |acc, i|
        if guess[i] == code[i]
          acc << CORRECT_POS
        elsif code.include?(guess[i])
          acc << CORRECT_COLOR
        else
          acc
        end
      end.sort.join
    end

    def over?(guess = @guesses.last)
      guess == @code
    end

    def win_message
      case @guesses.size
      when 1
        "Congratulations! You broke the code in 1 guess."
      when 2
        "Congratulations! You broke the code in 2 guesses."
      else
        "You broke the code in #{@guesses.size} guesses."
      end
    end

  end
end

