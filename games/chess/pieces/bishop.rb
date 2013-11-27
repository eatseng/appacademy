class Bishop < SlidingPiece
  def initialize(options)
    super(options)
    @move_deltas = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end