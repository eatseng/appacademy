class Pawn < Piece
  def moves
    possible_moves = []

    diagonal_up = [[1, 1], [1, -1]]
    cross_up    = [[1, 0]]
    start_up    = [[1, 0], [2, 0]]

    diagonal_dn = [[-1, 1], [-1, -1]]
    cross_dn    = [[-1, 0]]
    start_dn    = [[-1, 0],[-2, 0]]

    # movement
    deltas = cross_up if @color == "white"
    deltas = start_up if @color == "white" && @pos.first == 1
    deltas = cross_dn if @color == "black"
    deltas = start_dn if @color == "black" && @pos.first == 6

    deltas.each do |delta|
      i = @pos.first + delta.first
      j = @pos.last + delta.last
      next if !@board.move_within_bounds?([i, j])
      possible_moves << [i, j] if @board.empty_space?([i, j])
    end

    # capture
    deltas = diagonal_up if @color == "white"
    deltas = diagonal_dn if @color == "black"

    deltas.each do |delta|
      i = @pos.first + delta.first
      j = @pos.last + delta.last
        next if !@board.move_within_bounds?([i, j])

        #move on top of opposite color
        unless @board.empty_space?([i, j])
          if @board[i, j].color != @color
            possible_moves << [i, j]
            #stop at first enemy piece
            break
          end
        end
    end
    possible_moves
  end
end