require './chess_library.rb'
require './human_player.rb'

class Game
  def initialize(player1, player2)
    @board = Board.new
    @board.set_pieces
    @player1 = player1
    @player2 = player2
  end

  def play
    color = "black"

    until @board.checkmate?(color)
      system("clear")
      @board.print_board
      begin
        puts "\n#{color}'s turn."
        puts "you are in check." if @board.in_check?(color)

        player = (color == "white" ? @player2 : @player1)

        location = player.get_origin
        destination = player.get_destination
        @board.move(color, location, destination)

        color = (color == "white" ? "black" : "white")
      rescue  => e
        puts e
        retry
      end
    end

    @board.print_board
    puts "\n checkmate #{color}."
  end
end

if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new
  p2 = HumanPlayer.new
  g = Game.new(p1, p2)
  g.play
end