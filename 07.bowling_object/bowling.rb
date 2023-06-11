require './shot.rb'
require './frame.rb'
require './game.rb'

game = Game.new(ARGV[0])
game.calc_scores
