# frozen_string_literal: true

require_relative 'functions'
require 'yaml'

class Word
  include Tools
  include Display

  private

  def initialize
    variable
    pick_a_word
    @@code = @code.split('')
  end

  def pick_a_word
    word = @@dictionary.sample
    word.length > 6 ? @code = word : pick_a_word
  end
end

class Game < Word
  include Tools
  include Display

  private

  def initialize
    Word.new
    variable
    hanging_man
    new_game_display
    puts @tries0
    show_space(create_space(@@code))
    play_game(@@code)
    @empty = false
    replay
  end

  def new_game_display
    return unless @empty.nil?

    print @separator
    print "\nNEW GAME\n"
    puts @separator
  end
end

class Savings < Game
  include Tools
  include Display

  def initialize
    variable
    play_loaded_game
    replay
  end

  private

  def loading
    saved_files
    @saved_variables = YAML.safe_load(File.read(@filename))
    @saved_variables.each_index do |index|
      case index
      when 0
        @@code = @saved_variables[0]
      when 1
        @alphabet = @saved_variables[1]
      when 2
        @tries = @saved_variables[2]
      when 3
        @hangman_word = @saved_variables[3]
      when 4
        @used_letters = @saved_variables[4]
      end
    end
    remove_loaded_file(@filename)
  end

  def saved_files
    saved = Dir.open('saved').children
    saved_empty?(saved)
    display_loading_saves
    saved.each_with_index { |file, index| print "#{index + 1}) #{file}\n" }
    print "\nChoose the file by typing the relative number: "
    get_file(saved)
    @@code = []
    hanging_man
    @filename = "saved/#{@filename}"
  end

  def saved_empty?(saved)
    return unless saved.empty?

    @empty = true
    puts @red_separator
    puts "No savings found, play a new game!\n"
    puts @red_separator
    Game.new
  end

  def display_loading_saves
    print @red_separator
    print "\nLOAD GAME\n"
    puts @red_separator
    puts
  end
