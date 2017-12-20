require_relative "./game_view.rb" 
require_relative "./game_model.rb" 

ATTEMPTS_COUNT = 10
LENGTH_OF_CODE = 4

module Codebreaker
  class Game
    attr_reader :attemps_count, :attempts_array

    def initialize 
      default_settings
      @view = GameView.new
      @model = GameModel.new
    end

    def begin
      generate_secret_code
      @view.show_begin_game ATTEMPTS_COUNT
      play
    end

    def start(code)
      @attemps_count -= 1
      generate_secret_code

      if valid_secret_code? code
        check_hint(code)
        @attempts_array
      else
        raise "Invalid code"
      end
    end

    def reset 
      default_settings
    end

    def save
      @model.save_score(name, @attemps_count)
    end

    def win? secret_code
      @secret_code == secret_code ? true : false
    end

    def lose?
      @attemps_count == 0 
    end

    def max_attempts_count
      ATTEMPTS_COUNT
    end

    def hint
      random_index = rand(LENGTH_OF_CODE)
      @secret_code[random_index]
    end

    def statistics 
      @model.load_score
    end

    private

    def lose_message
      if @attemps_count == 0 
        @view.show_user_lost @secret_code
      end
    end

    def check_hint secret_code 
      count_plus = 0
      count_minus = 0

      @secret_code.each_char.with_index do |char, index|
        count_plus += 1 if char == secret_code[index] 
        count_minus += 1 if secret_code.include?(char)
      end

      count_minus -= count_plus
      
      result = ""
      count_plus.times { result << "+" }
      count_minus.times { result << "-" }
      result

      @attempts_array << { code: secret_code, matching: result }  
    end

    def play
      game_lifecycle
      lose_message

      answer = @view.play_again_answer.downcase
      play_again answer
    end

    def game_lifecycle
      while @attemps_count != 0 
        @view.show_attemps_count @attemps_count
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

        @attemps_count -= 1;
      end
    end

  

    def lose_message
      if @attemps_count == 0 
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
      @attemps_count = ATTEMPTS_COUNT
      @secret_code = ''
      @attempts_array = []
    end

    def play_again answer
      if answer == "yes" || answer == "y"
        default_settings
        start 
       else 
        name = @view.user_name
        @model.save_score(name, @attemps_count)
      end
    end
  end
end
