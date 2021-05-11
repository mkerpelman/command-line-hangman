require './lib/game.rb'

print "        Enter (1) to start a new game or enter (2) to load a saved game: "
choice = gets.chomp
until ["1", "2"].include?(choice)
    print "        Selection must be (1) or (2): "
    choice = gets.chomp
end
Game.new(choice)