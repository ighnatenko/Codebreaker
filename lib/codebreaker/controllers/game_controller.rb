require_relative "../views/game_view.rb" 
require_relative "../models/game_model.rb" 

COUNT_OF_ATTEMPS = 7
LENGTH_OF_CODE = 4

module Codebreaker
  class Game

    def initialize 
      default_settings
      @view = GameView.new
      @model = GameModel.new
    end

    def start
      generate_secret_code
      @view.show_begin_game COUNT_OF_ATTEMPS
      play
    end

    private

    def play
      game_lifecycle
      lose_message

      answer = @view.play_again_answer.downcase
      play_again answer
    end

    def game_lifecycle
      while @count_of_attemps != 0 
        @view.show_attemps_count @count_of_attemps
        secret_code = @view.secret_code

        unless valid_secret_code? secret_code
          @view.show_input_error
          next
        end
        
        if win? secret_code
          @view.show_user_win
          break
        end

        hint = guessed_numbers secret_code
        @view.show_hint(hint)

        @count_of_attemps -= 1;
      end
    end

    def win? secret_code
      @secret_code == secret_code ? true : false
    end

    def lose_message
      if @count_of_attemps == 0 
        @view.show_user_lost @secret_code
      end
    end

    def guessed_numbers secret_code 
      count_plus = 0
      count_minus = 0

      @secret_code.each_char.with_index do |char, index|
        count_plus += 1 if char == secret_code[index] 
        count_minus += 1 if secret_code.include?(char)
      end

      count_minus -= count_plus
      
      hint_result(count_plus, count_minus)
    end

    def hint_result(count_plus, count_minus)
      result = ""
      count_plus.times { result << "+" }
      count_minus.times { result << "-" }
      result
    end

    def valid_secret_code? secret_code
      if secret_code.length > LENGTH_OF_CODE || secret_code.length != LENGTH_OF_CODE || secret_code == ''
        false
      else
        true
      end
    end

    def generate_secret_code
      LENGTH_OF_CODE.times { @secret_code << random_value = rand(1..6).to_s }
    end

    def default_settings
      @count_of_attemps = COUNT_OF_ATTEMPS
      @secret_code = ''
    end

    def play_again answer
      if answer == "yes" || answer == "y"
        default_settings
        start 
       else 
        name = @view.user_name
        @model.save_score(name, @count_of_attemps)
      end
    end
  end
end

# load './lib/codebreaker/controllers/game_controller.rb'