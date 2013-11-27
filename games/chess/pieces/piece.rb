class Piece
  attr_accessor :color, :display_char, :pos, :board

  def initialize(options)
    @color = options[:color]
    @display_char = options[:display_char]
    @pos = options[:pos]
    @board = options[:board]
  end
end

class SlidingPiece < Piece
  def moves
    possible_moves = []

    @move_deltas.each do |delta|
      i = @pos.first
      j = @pos.last
      loop do
        i += delta.first
        j += delta.last
        break if !@board.move_within_bounds?([i, j])

        possible_moves << [i, j] if @board[i, j].nil?

        #move on top of opposite color
        unless @board[i, j].nil?
          if @board[i, j].color != @color
            possible_moves << [i, j]
            #stop at first enemy piece
          end
          break
        end
      end
    end
    possible_moves
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = []

    @move_deltas.each do |delta|
      i, j = delta.first, delta.last
      if @board.move_within_bounds?([@pos.first + i, @pos.last + j])
        calculate_move(possible_moves, i, j)
      end
    end
    possible_moves
  end

  protected

  def calculate_move(possible_moves, i, j)
    # move onto empty space
    if @board.empty_space?([@pos.first + i, @pos.last + j])
      possible_moves << [@pos.first + i, @pos.last + j]
    end

    # move onto opposite color
    unless @board.empty_space?([@pos.first + i, @pos.last + j])
      if @board[@pos.first + i, @pos.last + j].color != @color
        possible_moves << [@pos.first + i, @pos.last + j]
      end
    end
  end
end