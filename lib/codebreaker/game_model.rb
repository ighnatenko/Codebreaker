module Codebreaker
  class GameModel

    require 'yaml'

    USER_SCORE_PATH = './lib/codebreaker/user_score.yml'

    attr_reader :users

    def clear
      @users = {}
      save_user(@users)
    end

    def load_score
      @users = YAML.load_file(USER_SCORE_PATH)
    end

    def save_score(name, attempts)
      raise ArgumentError, "Name can't be empty" if name.nil?
      raise ArgumentError, "Attempts can't be empty" if attempts.nil?

      @users = load_score
      user = { name: name, score: attempts, time: Time.new }
      @users[name] = user
      save_user(@users)
    end
    
    private

    def save_user(users)
      File.new(USER_SCORE_PATH, 'w+') unless File.exist?(USER_SCORE_PATH)
      File.write(USER_SCORE_PATH, users.to_yaml)
    end
  end
end