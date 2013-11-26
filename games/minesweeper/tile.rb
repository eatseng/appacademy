class Tile
  attr_accessor :flagged, :revealed, :coords, :neighbor_bomb_count, :display_tile
  attr_reader :bomb

  def initialize(board_size, x_coord, y_coord)
    @coords = [x_coord, y_coord]
    @board_size = board_size
    @revealed = false
    @flagged = false
    @bomb = false
    @neighbor_bomb_count = 0
    @display_tile = "_"
  end

  def toggle_flag
    @flagged = (@flagged ? false : true)
  end

  def set_bomb
    @bomb = true
    @neighbor_bomb_count = :x
  end

  def display_tile
    if @flagged
      @display_tile = "F"
    elsif @revealed == false
      @display_tile = "*"
    elsif @bomb == false && @neighbor_bomb_count > 0
      @display_tile = @neighbor_bomb_count.to_s
    else
      @display_tile = "_"
    end
  end

  def return_neighbor_coordinates
    coord_array = []
    (-1).upto(1) do |x|
      (-1).upto(1) do |y|
        #check physical board boundary condition
        if (@coords.first + x).between?(0, @board_size - 1) && (@coords.last + y).between?(0, @board_size - 1)
          coord_array << [@coords.first + x, @coords.last + y] unless x == 0 && y == 0
        end
      end
    end
    coord_array
  end

end