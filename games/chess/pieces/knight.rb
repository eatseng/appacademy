class Knight < SteppingPiece
  def initialize(options)
    super(options)
    @move_deltas = [[ 2,  1], [ 1,  2], [-1,  2], [-2,  1],
                 [-1, -2], [-2, -1], [ 1, -2], [ 2, -1]]
  end
end