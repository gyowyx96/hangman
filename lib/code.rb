require_relative "functions.rb"

class Word
  include Tools 
  private
  
  def initialize
    variable   
    pick_a_word    
    # show_code(@code)#remove later
    @@code = @code.split("")
  end 

  def pick_a_word    
    word = @@dictionary.sample
    word.length > 6 ? @code = word : pick_a_word
  end
end

class PlayerInput < Word
  include Tools
  
  private 
  
  def initialize
    code = Word.new
    variable
    show_space(create_space(@@code))
    set_try
  end

  def ask_for_letter      
    @letter = gets.chomp.to_s.downcase
    if @letter.length != 1 || !@alphabet.include?(@letter)
      print "\nWrong input, or used letter, try again: "      
     return ask_for_letter
    end
    @alphabet.delete(@letter)
    @letter
  end 

  def set_try
    @tries = 6
    until @tries == 0 || @end == true do
      puts "\nTry left: #{@tries}\n\n"
      print "Give me a letter: "
      ask_for_letter
      play_round(@letter,@@code)      
    end
    if @end == false
    print "Loooooser!\nThis was the secret word: "
    show_code(@@code)
    puts @red_separator
    end
  end

  def win_condition(code, input)
    code.delete("\n")
    code = code.join("")
    input = input.join("")
    if code == input
      puts @red_separator
      puts "\nHAI VINTO!!!!!!!"
      return @end = true
    end
  end
end

n1 = PlayerInput.new



