require './board'
require 'yaml'


class Game
  def initialize
    @mine_sweeper = Board.new(9)
  end

  def play
    puts "Enter s to save or l to load any time"

    until @mine_sweeper.game_over
      @mine_sweeper.print_tile
      puts "Please enter tile x cooordinate"
      x = gets.chomp
      break if x == 's' || x == 'l'

      puts "Please enter tile y cooordinate"
      y = gets.chomp
      break if y == 's' || y == 'l'

      puts "Toggle flag spot? Y/N (Otherwise just reveal)"
      flag = gets.chomp
      break if flag == 's' || flag == 'l'

      @mine_sweeper.interface([y.to_i, x.to_i], flag)
    end

    if x == 'l' || y == 'l' || flag == 'l'
      load
    elsif x == 's' || y == 's' || flag == 's'
      save
    end

  end

  def save
    serialized = @mine_sweeper.to_yaml
    File.open("mine_sweeper.txt", "w") do |f|
      f.puts serialized
    end
  end

  def load
    contents = File.read("mine_sweeper.txt")
    @mine_sweeper = YAML::load(contents)
    play
  end


end

game = Game.new
game.play

size = 3
=begin
matrix = Array.new(size) {Array.new(size)}

counter = 0
matrix.each_with_index do |row, i|
  row.each_with_index do |col, j|
     matrix[i][j] = counter
     counter += 1
  end
end

matrix.each_with_index do |row, j|
  p row
end


matrix.each_with_index do |row, i|
  row.each_with_index do |col, j|
     p matrix[i][j]
  end
end

(0...size).each do |i|
  (0...size).each do |j|
    p matrix[i][j]
  end
end

p matrix[0][1]
=end