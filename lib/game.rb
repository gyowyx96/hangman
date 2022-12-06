require_relative "functions.rb"
require 'yaml'

class Word
  include Tools
  include Display
  
  private
  
  def initialize
    variable   
    pick_a_word
    @@code = @code.split("")
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
    code = Word.new
    variable
    show_space(create_space(@@code))
    play_game(@@code)
    exit
  end
end

class Savings < Game
  include Tools
  include Display

  public

  def initialize
    variable
    play_loaded_game    
  end

  private 

  def loading
    @@code = []  
    get_saved_files
    @saved_variables = YAML.load(File.read(@filename))
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
    puts @@code.join
    remove_loaded_file(@filename)
  end

  def get_saved_files
    saved = Dir.open("saved").children
    if saved.empty?
      puts "No savings found, play a new game!\n"
      puts @red_separator
      return Game.new
    end 
    saved.each_with_index do |file, index|
      print "#{index+1}) #{file}\n"
    end
    print"Choose the file by typing the relative number: "
    get_file(saved)
    @filename = "saved/#{@filename}"    
  end

  def get_file(saved)
    index = gets.chomp.to_i
    if saved[index - 1].nil?
      print "Wrong input, try again: "
      get_file(saved)
    else
      @filename = saved[index - 1] 
    end
  end

  def play_loaded_game
    loading
    print "\nHere is the last used words: "
    show_space(@used_letters)
    puts
    show_space(@hangman_word)
    play_game(@@code)
  end

  def remove_loaded_file(filename)
      File.delete(filename)    
  end
end