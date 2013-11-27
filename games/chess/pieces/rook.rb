class Rook < SlidingPiece
  def initialize(options)
    super(options)
    @move_deltas = [[1, 0], [0,  1], [-1,  0], [0, -1]]
  end
end