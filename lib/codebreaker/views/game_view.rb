class GameView

  def show_hint text
    puts "#{text}"
  end

  def show_begin_game count
    puts "Game begin"
    puts "Enter the secret_code ****, you have #{count} attempts"
  end

  def secret_code
    gets.chomp
  end

  def show_attemps_count attemps_count
    puts "You have #{attemps_count} attempts"
  end

  def show_input_error
    puts "Please enter only 4 numbers !!!"
  end

  def show_user_win
    puts "You WON !!!"
  end

  def show_user_lost secret_code
    puts "Sorry, you loser !!! Code = #{secret_code}"
  end

  def user_name 
    puts "What is your name ?"
    name = gets.chomp 
    name = "Empty name" if name == "" 
    puts "#{name} is saved "
    name
  end

  def play_again_answer
    puts "Do you want to start the game again? (yes / no)"
    answer = gets.chomp
  end

end



