# frozen_string_literal: true

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
    @alphabet = ('a'..'z').to_a
    @used_letters = []
    @tries = 6
    @separator = '                                                          '.bg_cyan
    @red_separator = '                                                          '.bg_red
    @end = false
  end

  private

  # save the game
  def save(code)
    Dir.mkdir('saved') unless Dir.exist?('saved')

    print 'What name do you wanna give to yours saves: '
    name = gets.chomp
    filename = "saved/load_#{name}.yaml"

    saved_variables = [code, @alphabet, @tries, @hangman_word, @used_letters]

    File.open(filename, 'w') { |file| file.write(saved_variables.to_yaml) }
  end

  # wait for an input of the player and check it
  def ask_for_letter(code)
    @letter = gets.chomp.to_s.downcase
    if @letter == 'save'
      puts "\nSaving...."
      save(code)
      exit
    end
    exit if @letter == 'quit'
    if @letter.length != 1 || !@alphabet.include?(@letter)
      print "\nWrong input, or used letter, try again: "
      return ask_for_letter(code)
    end
    @alphabet.delete(@letter)
    @letter
  end

  # let you play the game for a pre-imposted number of rounds
  def play_game(code)
    until @tries.zero? || @end == true
      puts "\nTry left: #{@tries}\n\n"
      print 'Type a letter to play, save, or quit: '
      ask_for_letter(code)
      play_round(@letter, code)
    end
    return unless @end == false

    looser_banner
    print "\nThis was the secret word: "
    show_code(code)
    replay
  end

  def play_round(letter, code)
    puts
    update_tries(letter, code)
    update_diplay(letter, code)
    win_condition(code, @hangman_word)
    puts
    puts @separator
  end
end

module Display
  private

  # update the display after the move of the player
  def update_diplay(input, code)
    if code.include?(input)
      @used_letters.push(input.green)
      print 'Nice, it was inside the misteryous word: '
      show_space(@used_letters)
      code.each_with_index { |letter, index| @hangman_word[index] = letter if letter == input }
    else
      @used_letters.push(input.red)
      print 'SHIP it wasnt inside the word: '
      show_space(@used_letters)
    end
    puts
    show_space(@hangman_word)
  end

  def update_tries(input, code)
    @tries -= 1 unless code.include?(input)
  end

  def show_space(code)
    code.each { |word| print "#{word} " }
    puts
  end

  def show_code(code)
    puts code.join('')
  end

  def win_condition(code, input)
    code.delete("\n")
    code = code.join('')
    input = input.join('')
    return unless code == input

    winner_banner
    @end = true
  end

  def create_space(word)
    space = word.length - 1
    space.times do
      @hangman_word.push('_')
    end
    @hangman_word
  end

  def winner_banner
    upper = '           '.bg_green
    text = 'YOU WON'.cyan
    green = ' '.bg_green
    puts
    puts "#{upper}\n#{green}         #{green}\n#{green} #{text} #{green}\n#{green}         #{green}\n#{upper}"
  end

  def looser_banner
    upper = '            '.bg_red
    text = 'YOU LOST'.blue
    red = ' '.bg_red
    puts "#{upper}\n#{red}          #{red}\n#{red} #{text} #{red}\n#{red}          #{red}\n#{upper}"
  end

  def replay
    print 'Do you wanna play again? y/n: '
    asked_input = gets.chomp.capitalize!.slice(0)
    return puts 'It was a pleasure to play with you bye bye !' unless asked_input == 'Y'

    Game.new
  end
end
