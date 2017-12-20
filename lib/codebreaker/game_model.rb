require 'pp'
require 'marshal/structure'

class GameModel

  USER_SCORE_PATH = './lib/codebreaker/user_score.txt'

  def load_score
    File.open(USER_SCORE_PATH,"rb") { |f| @user = Marshal.load(f) }
    @user
  end

  def save_score(name, attempts)  
    @user = { :name => user_name, :score => user_attempts, :time => Time.new }
    File.open(USER_SCORE_PATH, "wb") do |file|
      Marshal.dump(@user, file)
    end
  end
  
end
