# frozen_string_literal: true

require_relative 'functions'
require_relative 'game'
require 'yaml'

class PlayTheGame < Savings
  def initialize
    puts "Choose if you wanna load a game or create a new one:
          1) New Game
          2) Load Game"
    select_mode
    Game.new if @choice == '1'
    Savings.new if @choice == '2'
  end

  def select_mode
    choice = gets.chomp
    if choice != '1' && choice != '2'
      print "\nError! wrong input, try again: "
      select_mode
    end
    @choice = choice
  end
end
PlayTheGame.new
