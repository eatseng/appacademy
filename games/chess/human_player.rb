class HumanPlayer
  def initialize
  end

  def get_origin
    puts "select piece to move (ie '2, 3' for row 2, column 3)"
    gets.chomp.split(', ').map(&:to_i)
  end

  def get_destination
    puts "select location to move to"
    gets.chomp.split(', ').map(&:to_i)
  end
end