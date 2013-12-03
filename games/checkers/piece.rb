class Piece
  attr_accessor :pos
  attr_reader :type, :color

  def initialize(options = {})
    @color = options[:color]
    @type = options[:type]
    @pos = options[:pos]
    @board = options[:board]
    @direction = []
  end

  def retrieve_options
    {:color => @color, :type => @type, :pos => @pos, :@board => @board}
  end

  def valid_moves
    valid_moves = []
    
    @direction.each do |move_delta|
      i = @pos.first + move_delta.first
      j = @pos.last + move_delta.last
      move = [i, j]
      jump_move = [@pos.first + 2 * move_delta.first, @pos.last + 2 * move_delta.last]
      next unless @board.on_the_board?(move)
      
      valid_moves << move if @board[i, j].nil?

      unless @board[i, j].nil?      
        valid_moves << jump_move if @board[i,j].color != @color
      end
    end
    valid_moves
  end

end

class Pawn < Piece
  BPAWN_MOVES = [[1, -1], [1, 1]]
  WPAWN_MOVES = [[-1, -1], [-1, 1]]
  def initialize(options)
    super(options)
    @direction = (@color == :white ? WPAWN_MOVES : BPAWN_MOVES)
  end
end

class King < Piece
  KING_MOVES = [[1, -1], [1, 1], [-1, -1], [-1, 1]]

  def initialize(options)
    super(options)
    @direction = KING_MOVES
  end
end


