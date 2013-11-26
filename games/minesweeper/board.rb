require './tile'
require 'set'

class Board
  attr_reader :matrix, :size, :game_over

  def initialize(size)
    @game_over = false
    @size = size
    @matrix = Array.new(@size) {Array.new(@size)}
    initialize_tiles
    assign_bomb_locations
    calculate_tile_neighbor_bombs
    print_board
    #print_tile
  end

  def calculate_tile_neighbor_bombs
    @size.times do |y|
      @size.times do |x|
        next if @matrix[y][x].bomb
        tile_neighbors = @matrix[y][x].return_neighbor_coordinates
        bomb_count = tile_neighbors.select do |coords|
          @matrix[coords[1]][coords[0]].bomb == true
        end.length
        @matrix[y][x].neighbor_bomb_count = bomb_count
      end
    end
  end

  def interface(coords, flag)
    if flag.upcase == "Y"
      @matrix[coords.first][coords.last].toggle_flag
    else
      current_tile = @matrix[coords.first][coords.last]
      current_tile.revealed = true
      reveal_tile(current_tile) if current_tile.neighbor_bomb_count == 0
      check_game_win
      game_over_lose if current_tile.bomb
    end

  end

  def check_game_win
    unrevealed_count = 0
    @matrix.each_with_index do |row, y|
      row.each_index do |x|
        unrevealed_count += 1 if @matrix[y][x].revealed == false
      end
    end
    if @size == unrevealed_count
      game_over_win
    end
  end

  def game_over_win
    puts "You win!"
    print_board
    @game_over = true
  end

  def game_over_lose
    puts "you lose!"
    print_board
    @game_over = true
  end

  # REFACTOR

  def reveal_tile(tile)
    queue = [tile]
    tiles_visited = Set.new
    until queue.empty?
      tile_to_expand = queue.shift
      tiles_visited << tile_to_expand
      unless tile_to_expand.flagged
        #pull out starting here
        tile_to_expand.revealed = true

        tile_to_expand.return_neighbor_coordinates.each do |neighbor_tile|
          current_tile = @matrix[neighbor_tile.last][neighbor_tile.first]
          if current_tile.neighbor_bomb_count == 0
            queue << current_tile unless tiles_visited.include?(current_tile)
          elsif current_tile.neighbor_bomb_count > 0 && current_tile.neighbor_bomb_count < 9
            current_tile.revealed = true
          end
        end
        # refactoring end here
      end
    end
  end



  def print_board
    display_array = Array.new(@size) {Array.new(@size)}
    @size.times do |y|
      @size.times do |x|
        display_array[y][x] = @matrix[y][x].neighbor_bomb_count
      end
    end
    display_array.each do |row|
      p row
    end
  end

  def print_tile
    display_array = Array.new(@size) {Array.new(@size)}
    @size.times do |y|
      @size.times do |x|
        display_array[y][x] = @matrix[y][x].display_tile
      end
    end
    display_array.each do |row|
      p row
    end
  end


  private

  def initialize_tiles
    @matrix.each_with_index do |row, y_coord|
      row.each_with_index { |tile, x_coord|
        @matrix[y_coord][x_coord] = Tile.new(@size, x_coord, y_coord) }
    end
  end

  def assign_bomb_locations
    coordinates = []
    until coordinates.length == @size
      location = [rand(@size), rand(@size)]
      coordinates << location unless coordinates.include?(location)
    end

    coordinates.each do |location|
      @matrix[location.first][location.last].set_bomb
    end
  end
end

