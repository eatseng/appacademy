require "./checkers_library.rb"

class Game
  def initialize
    @board = Board.new
    @board.setup_board
  end

  def play
    color = :black
    until win?(color) do
      @board.print_board
      color = (color == :black ? :white : :black)

      p "#{color.to_s}'s turn"
      begin
        puts "Enter coordinate of starting piece (i,e. '2, 3') (q to quit)"
        start_pos = gets.chomp
        break if start_pos == 'q'
        start_pos = start_pos.split(",").map { |e| e.to_i}
        
        puts "Enter coordinate of destination"
        end_pos = gets.chomp.split(",").map { |e| e.to_i}.each_slice(2).to_a
   
        @board.perform_move(color, start_pos, end_pos)
      rescue ArgumentError => e_msg
        puts e_msg
        retry
      end
    end
    end_of_game_msg(color) if start_pos.class != String
  end

  def win?(color)
    color = (color == :black ? :white : :black)
    @board.piece_left?(color)
  end

  def end_of_game_msg(color)
    puts "#{color} won!!!"
  end
end



game = Game.new
game.play