require 'yaml'

module Codebreaker
  class GameModel

    FILE_NAME = 'user_score.yml'

    def clear
      save_user(File.join(__dir__, FILE_NAME), {})
    end

    def load_score
      YAML::load_file(File.join(__dir__, FILE_NAME))
    end

    def save_score(name, attempts)
      raise ArgumentError, "Name can't be empty" if name.nil?
      raise ArgumentError, "Attempts can't be empty" if attempts.nil?

      users = load_score
      user = { name: name, score: attempts, time: Time.new }
      users[name] = user

      save_user(File.join(__dir__, FILE_NAME), users)
    end

    private

    def save_user(path, users)
      File.new(path, 'w+') unless File.exist?(path)
      File.write(path, users.to_yaml)
    end
  end
end