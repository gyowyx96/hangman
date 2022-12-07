# frozen_string_literal: true

# colors
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

# module that contains most of the game functions
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

    print 'What name do you wanna give to your file: '
    name = gets.chomp.rstrip
    filename = "saved/#{name}.yaml"

    saved_variables = [code, @alphabet, @tries, @hangman_word, @used_letters]

    File.open(filename, 'w') { |file| file.write(saved_variables.to_yaml) }
  end

  # wait for an input of the player and check it
  def ask_for_letter(code)
    @letter = gets.chomp.to_s.downcase.rstrip
    check_input(@letter, code)
    if @letter.length != 1 || !@alphabet.include?(@letter)
      print "\nWrong input, or used letter, try again: "
      return ask_for_letter(code)
    end
    @alphabet.delete(@letter)
    @letter
  end

  # check if the typed input was a command like save/quit
  def check_input(letter, code)
    if letter == 'save'
      puts "\nSaving...."
      save(code)
      exit
    end
    exit if letter == 'quit'
  end

  # let you play the game for a pre-imposted number of rounds
  def play_game(code)
    hanging_man
    until @tries.zero? || @end == true
      print "\nType a letter to play, save, or quit: "
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
    system 'clear'
    update_tries(letter, code)
    update_diplay(letter, code)
    win_condition(code, @hangman_word)
    puts
    puts @separator
  end
end

# update display methods
module Display
  def hanging_man
    @tries6 = '
          _____
          |   |
          |   ◉
          |  /|\
          |  / \
        __|__
        '
    @tries5 = '
          _____
          |   |
          |   ◉
          |  /|\
          |  /
        __|__
        '
    @tries4 = '
          _____
          |   |
          |   ◉
          |  /|\
          |
        __|__
        '

    @tries3 = '
          _____
          |   |
          |   ◉
          |  /|
          |
        __|__
        '
    @tries2 = '
          _____
          |   |
          |   ◉
          |   |
          |
        __|__
        '

    @tries1 = '
          _____
          |   |
          |   ◉
          |
          |
        __|__
        '
    @tries0 = '
          _____
          |   |
          |
          |
          |
        __|__
        '
    @hangman_array = [@tries6, @tries5, @tries4, @tries3, @tries2, @tries1, @tries0]
  end

  private

  # update the display after the move of the player
  def update_diplay(input, code)
    code.include?(input) ? included_in_code(input, code) : not_included_in_code(input)
    puts
    show_space(@hangman_word)
  end

  # if the letter typed is included it respond to this
  def included_in_code(input, code)
    @used_letters.push(input.green)
    print 'Nice, it was inside the misteryous word: '
    show_space(@used_letters)
    puts @hangman_array[@tries]
    code.each_with_index { |letter, index| @hangman_word[index] = letter if letter == input }
  end

  # if is not included instead respond to this
  def not_included_in_code(input)
    @used_letters.push(input.red)
    print 'SHIP it wasnt inside the word: '
    show_space(@used_letters)
    puts @hangman_array[@tries]
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
    puts
    puts "#{upper}\n#{red}          #{red}\n#{red} #{text} #{red}\n#{red}          #{red}\n#{upper}"
  end

  def replay
    print 'Do you wanna play again? y/n: '
    asked_input = gets.chomp.capitalize!.slice(0)
    if asked_input == 'N'
      puts 'It was a pleasure to play with you bye bye !'
      exit
    end
    system 'clear'
    Game.new
  end
end

# helper method module
module Helper
  def show_rules
    system 'clear'
    variable
    colored_red = 'Game-Rules'.red
    print @separator
    puts @red_separator
    puts "\n                                                      #{colored_red}\n
    Hangman is a guessing game against the pc.
    A word that exist will be generated automatically by the pc.
    Your objective is to identify that word within a certain number of guesses.
    You can guess only one letter per turn and if it is wrong the number of tries will be decreased.
    If you reach 0 tries you loose!\n\n"
    print @red_separator
    puts @separator
  end
end
