class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

module Tools

  def variable 
    @@dictionary = File.open('dictionary.txt').to_a
    @hangman_word = []
    @alphabet = ("a".."z").to_a
    @used_letters = []
    @tries = 10
    @separator = "                                                          ".bg_cyan
    @red_separator = "                                                          ".bg_red
    @end = false
  end

  private

  def play_round(letter, code)
    puts
    update_tries(letter, code)
    update_diplay(letter, code)
    win_condition(code, @hangman_word)
    puts
    puts @separator
  end

  def update_diplay(input, code)
    if code.include?(input)
      @used_letters.push(input.green)
      print "Nice, it was inside the misteryous word: "
      show_space(@used_letters)
      code.each_with_index { |letter, index| @hangman_word[index] = letter if letter == input }
    else
      @used_letters.push(input.red)
      print "SHIP it wasnt inside the word: "
      show_space(@used_letters)        
    end
    puts
    show_space(@hangman_word)
  end

  def update_tries(input, code)
    @tries -= 1 if !code.include?(input)
  end

  def show_space(code)
    code.each {|word| print "#{word} "}
    puts
  end
  
  def show_code(code)
    puts code.join("")
  end

  def create_space(word)    
    space = word.length - 1 
    space.times do
      @hangman_word.push("_")
    end
    @hangman_word
  end
end