module Codebreaker
  class GameModel

    require 'pp'
    require 'marshal/structure'

    USER_SCORE_PATH = './lib/codebreaker/user_score.txt'

    attr_reader :users

    def clear
      @users = []
      save_user(@users)
    end

    def load_score
      File.open(USER_SCORE_PATH, 'rb') { |f| @users = Marshal.load(f) }
      @users
    end

    def save_score(name, attempts)
      raise ArgumentError, "Name can't be empty" if name.nil?
      raise ArgumentError, "Attempts can't be empty" if attempts.nil?

      @users = load_score
      user = { name: name, score: attempts, time: Time.new }
      @users << user
      save_user(@users)
    end
    
    private

    def save_user(users)
      File.open(USER_SCORE_PATH, 'wb') do |file|
        Marshal.dump(users, file)
      end
    end
  end
end