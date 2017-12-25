require_relative './game_model.rb'

ATTEMPTS_COUNT = 10
CODE_LENGTH = 4

module Codebreaker
  class Game
    attr_reader :attemps_count, :hint_array

    def initialize
      @model = Codebreaker::GameModel.new
    end

    def start
      puts 'The game has begun'
      default_settings
      generate_secret_code
    end

    def guess(code)
      @attemps_count -= 1

      if valid_secret_code?(code)
        add_hint(guessed_hint(@secret_code, code)) if @attemps_count != 0
      else
        raise 'Invalid code'
      end

      puts "#{@attemps_count} out of #{ATTEMPTS_COUNT} attempts left"
    end

    def reset
      default_settings
      generate_secret_code
    end

    def save(name, attemps_count)
      @model.save_score(name, attemps_count)
    end

    def win?(input_code)
      @secret_code == input_code
    end

    def lose?
      @attemps_count.zero?
    end

    def max_attempts_count
      ATTEMPTS_COUNT
    end

    def hint
      random_index = rand(CODE_LENGTH)
      @secret_code[random_index]
    end

    def statistics
      @model.load_score
    end

    private

    def valid_secret_code?(secret_code)
      if secret_code.length > CODE_LENGTH || secret_code.length < CODE_LENGTH
        false
      else
        true
      end
    end

    def generate_secret_code
      CODE_LENGTH.times { @secret_code << rand(1..6).to_s }
    end

    def default_settings
      @attemps_count = ATTEMPTS_COUNT
      @secret_code = ''
      @hint_array = []
    end

    def guessed_hint(secret_code, input_code)
      count_plus = 0
      count_minus = 0

      secret_code.each_char.with_index do |char, index|
        count_plus += 1 if char == input_code[index]
        count_minus += 1 if input_code.include?(char)
      end

      count_minus -= count_plus
      result = ''
      count_plus.times { result << '+' }
      count_minus.times { result << '-' }

      result == '' ? nil : { code: input_code, matching: result }
    end

    def add_hint(hint_hash)
      @hint_array << hint_hash unless hint_hash.nil?
    end
  end
end