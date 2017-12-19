require 'pp'
require 'marshal/structure'

class GameModel

  USER_SCORE_PATH = './lib/codebreaker/db/user_score.txt'

  def load_score
    File.open(USER_SCORE_PATH,"rb") { |f| @user = Marshal.load(f) }
    @user
  end

  def save_score(user_name, user_attempts)  
    @user = { :user_name => user_name, :user_attempts => user_attempts }
    File.open(USER_SCORE_PATH, "wb") do |file|
      Marshal.dump(@user, file)
    end
  end
  
end

# load './lib/codebreaker/models/game_model.rb'