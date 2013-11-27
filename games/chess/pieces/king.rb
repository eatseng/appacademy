class King < SteppingPiece
  def initialize(options)
    super(options)
    @move_deltas = [[-1, 1], [0,  1], [ 1,  1], [ 1, 0],
            [1, -1], [0, -1], [-1, -1], [-1, 0]]
  end
end