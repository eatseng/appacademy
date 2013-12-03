require "./piece.rb"
require "./exception.rb"
require "colorize"


class Board
  attr_accessor :matrix

  def initialize(size = 8, board = nil)
    @size = size
    @matrix = Array.new (size + 1) { Array.new(size + 1) }
    @matrix = board unless board.nil?

    #test_pieces
    #print_moves(@test_piece)
  end

  def on_the_board?(coord)
    return false unless coord.first.between?(1, @size) 
    coord.last.between?(1, @size)
  end

  def setup_board
    white_options = {:color => :white, :type => " WP ", :board => self}
    black_options = {:color => :black, :type => " BP ", :board => self}
    
    @matrix.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        if i.even?
          matrix[i][j] = Pawn.new(white_options) if i > 5 && j.odd?
          matrix[i][j] = Pawn.new(black_options) if i < 4 && j.odd?
        else
          matrix[i][j] = Pawn.new(white_options) if i > 5 && j.even?
          matrix[i][j] = Pawn.new(black_options) if i < 4 && j.even?
        end
      end
    end
    update_piece_position
  end

  def test_pieces
    white_options = {:color => :white, :type => " WP ", :board => self}
    black_options = {:color => :black, :type => " BP ", :board => self}
    @test_piece = Pawn.new(black_options)
    @matrix[5][5] = @test_piece
    @matrix[7][3] = Pawn.new(black_options)
    @matrix[8][2] = Pawn.new(white_options)
    #@matrix[6][2] = Pawn.new(white_options)

    update_piece_position

    print_moves(@test_piece)
  end


  def perform_move(color, starting_pos, ending_pos)
    check_exceptions(color, starting_pos, ending_pos)    
    piece = @matrix[starting_pos.first][starting_pos.last]

    move_piece(starting_pos, ending_pos)
    delete_piece(starting_pos, ending_pos) if valid_jump_move?(starting_pos, ending_pos.first)

    #performing multiple jumps if multiple coordinates are passed in
    duped_board = self.dup
    begin
      perform_move!(color, starting_pos, ending_pos) if ending_pos.length > 1
    rescue InvalidMoveError => e_msg
      p e_msg
      @matrix = duped_board.matrix
      raise ArgumentError.new "Invalid jump move for the starting piece"
    end

    promote_piece(piece) if to_promote?(piece)
  end

  def perform_move!(color, starting_pos, ending_pos)
    starting_pos = ending_pos.shift
    return true if ending_pos.length == 0
    
    piece = @matrix[starting_pos.first][starting_pos.last]
    
    raise InvalidMoveError.new "Invalid jump move" unless \
      valid_move?(piece, ending_pos.first) && valid_jump_move?(starting_pos, ending_pos.first)
    
    move_piece(starting_pos, ending_pos)
    delete_piece(starting_pos, ending_pos)

    perform_move!(color, starting_pos, ending_pos)
  end

  def piece_left?(color)
    pieces = []
    @matrix.each_with_index do |row, i|
      row.each_with_index do |element, j|
        pieces << @matrix[i][j] if !element.nil? && element.color == color
      end
    end
    pieces.length == 0
  end

  def print_board
    display_array = self.dup.matrix
    
    display_array.each_with_index do |row, i|
      row.each_with_index do |col, j|
        display_array[i][j] = "    "
        display_array[i][j] = "#{@matrix[i][j].type}" unless @matrix[i][j].nil?
      end
    end

    display_array.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        print j.to_s + "   " if i == 0 && j != 0
        print i.to_s + "  " if j == 0
        if i.even?
          print display_array[i][j].colorize(:background => :black) if j.even? && ( i != 0 && j != 0 )
          print display_array[i][j].colorize(:background => :red) if j.odd? && ( i != 0 && j != 0 )
        else
          print display_array[i][j].colorize(:background => :red) if j.even? && ( i != 0 && j != 0 )
          print display_array[i][j].colorize(:background => :black) if j.odd? && ( i != 0 && j != 0 )
        end
      end
      print "\n"
    end
  end

  def print_moves(piece)
    display_array = self.dup.matrix

    piece.valid_moves.each do |move|
        display_array[move.first][move.last] = " O  "
    end

    display_array.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        print j.to_s + "   " if i == 0 && j != 0
        print i.to_s + "  " if j == 0
        if ele.class == Pawn || ele.class == King
          print ele.type
        else
          print ele
        end
        print "nil " if ele.nil? && ( i != 0 && j != 0 )
      end
      print "\n"
    end
  end


  def [](i, j)
    @matrix[i][j]
  end

  def []=(i, j, val)
    @matrix[i][j] = val
  end

  protected

  def update_piece_position
    @matrix.each_with_index do |row, i|
      row.each_with_index do |ele, j|
        ele.pos = [i, j] unless ele.nil?
      end
    end
  end

  def check_exceptions(color, starting_pos, ending_pos)
    raise ArgumentError.new "Starting/ending position is not on game board" unless \
      on_the_board?(starting_pos) && ending_pos.all? {|ep| p on_the_board?(ep)}
    
    raise ArgumentError.new "No piece at starting position" if \
      @matrix[starting_pos.first][starting_pos.last].nil?

    raise ArgumentError.new "Wrong color selected" if \
      @matrix[starting_pos.first][starting_pos.last].color != color

    raise ArgumentError.new "Invalid move for the starting piece" unless \
      valid_move?(@matrix[starting_pos.first][starting_pos.last], ending_pos.first)
  end

  def valid_jump_move?(starting, ending)
    ((starting.first - ending.first).abs + (starting.last - ending.last).abs) == 4
  end

  def valid_move?(piece, ending_pos)
    piece.valid_moves.any? {|move| move == ending_pos}
  end

  def to_promote?(piece)
    return true if piece.pos.first == 1 && piece.color == :white
    (piece.pos.first == 8 && piece.color == :black)
  end

  def move_piece(starting_pos, ending_pos)
    e_i = ending_pos.first.first
    e_j = ending_pos.first.last
    @matrix[e_i][e_j] = @matrix[starting_pos.first][starting_pos.last]
    @matrix[e_i][e_j].pos = ending_pos.first
    @matrix[starting_pos.first][starting_pos.last] = nil
  end

  def delete_piece(starting_pos, ending_pos)
    del_i = (ending_pos.first.first - starting_pos.first) / 2 + starting_pos.first
    del_j = (ending_pos.first.last - starting_pos.last) / 2 + starting_pos.last
    @matrix[del_i][del_j] = nil
  end

  def promote_piece(piece)
    options = piece.retrieve_options
    options[:type] = (piece.color == :white ? " WK " : " BK ")
    options[:board] = self
    @matrix[piece.pos.first][piece.pos.last] = King.new(options)
  end

  def dup
    duped_board = Board.new(@size)
        
    @matrix.each_with_index do |row, i|
      row.each_with_index do |element, j|
        unless element.nil?
          options = element.retrieve_options
          options[:board] = duped_board #create a new board class
          duped_board.matrix[i][j] = element.class.new(options)
        end
      end
    end
    duped_board
  end
end
