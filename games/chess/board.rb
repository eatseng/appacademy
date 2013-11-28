require './chess_library.rb'
require 'colorize'

class Board
  attr_reader :matrix, :board_size, :white_pieces, :black_pieces

  def initialize (board_size = 8)
    @board_size = board_size
    @matrix = Array.new(@board_size) { Array.new(@board_size) }
    @white_pieces = []
    @black_pieces = []
  end

  def set_pieces
    [0, 1, 6, 7].each do |row|
      color = "white" if row == 0 || row == 1
      color = "black" if row == 7 || row == 6

      option = {:color => color, :board => self, :pos => [row, 0]}
        option[:display_char] = (color == "white" ? "\u2656" : "\u265C")
      @matrix[row][0] = Rook.new(option)

      option = {:color => color, :board => self, :pos => [row, 1]}
        option[:display_char] = (color == "white" ? "\u2658" : "\u265E")
      @matrix[row][1] = Knight.new(option)

      option = {:color => color, :board => self, :pos => [row, 2]}
        option[:display_char] = (color == "white" ? "\u2657" : "\u265D")
      @matrix[row][2] = Bishop.new(option)

      option = {:color => color, :board => self, :pos => [row, 3]}
        option[:display_char] = (color == "white" ? "\u2655" : "\u265B")
      @matrix[row][3] = Queen.new(option)

      option = {:color => color, :board => self, :pos => [row, 4]}
        option[:display_char] = (color == "white" ? "\u2654" : "\u265A")
      @matrix[row][4] = King.new(option)

      option = {:color => color, :board => self, :pos => [row, 5]}
        option[:display_char] = (color == "white" ? "\u2657" : "\u265D")
      @matrix[row][5] = Bishop.new(option)

      option = {:color => color, :board => self, :pos => [row, 6]}
      option[:display_char] = (color == "white" ? "\u2658" : "\u265E")
      @matrix[row][6] = Knight.new(option)

      option = {:color => color, :board => self, :pos => [row, 7]}
        option[:display_char] = (color == "white" ? "\u2656" : "\u265C")
      @matrix[row][7] = Rook.new(option)

      if row == 1 || row == 6
        (0...8).each do |i|
          option = {:color => color, :board => self, :pos => [row, i]}
          option[:display_char] = (color == "white" ? "\u2659" : "\u265F")
          @matrix[row][i] = Pawn.new(option)
        end
      end
    end


    @matrix.each do |row|
      row.each do |square|
        @white_pieces << square if !square.nil? && square.color == "white"
        @black_pieces << square if !square.nil? && square.color == "black"
      end
    end
  end


  def print_board
    display_array = Array.new(8) { Array.new(8) }
    @matrix.each_with_index do |row, i|
      row.each_with_index do |col, j|
        display_array[i][j] = "  "
        display_array[i][j] = "#{@matrix[i][j].display_char} " unless @matrix[i][j].nil?
      end
    end

    display_array.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if i.even?
          print display_array[i][j].colorize(:background => :blue) if j.even?
          print display_array[i][j].colorize(:background => :black) if j.odd?
        else
          print display_array[i][j].colorize(:background => :black) if j.even?
          print display_array[i][j].colorize(:background => :blue) if j.odd?
        end
      end
      print "\n"
    end
  end


  def checkmate?(color)
    checkmate = false
    color_pieces = (color == "white" ? @white_pieces : @black_pieces)
    if in_check?(color)
      checkmate = true
      color_pieces.each do |piece|
        destinations = piece.moves
        valid_moves = destinations.select { |dest| valid_move?(piece, dest) }
        return false if valid_moves.any?
      end
    end
    checkmate
  end


  def move(color, origin, destination)
    raise ArgumentError.new "POSITION IS EMPTY" if @matrix[origin.first][origin.last].nil?

    #get piece from initial space
    piece = @matrix[origin.first][origin.last]

    raise ArgumentError.new "WRONG COLOR SELECTED" if piece.color != color
    raise ArgumentError.new "INVALID MOVE" if !check_move?(piece, destination)
    raise ArgumentError.new "MOVE LEAVES KING IN CHECK" if !valid_move?(piece, destination)

    #move piece to destination & set location in piece object
    @matrix[destination.first][destination.last] = piece
    piece.pos = [destination.first, destination.last]
    @matrix[origin.first][origin.last] = nil
  end


  def check_move?(piece, destination)
    piece.moves.include?(destination)
  end


  def valid_move?(piece, destination)
    new_board = self.dup
    new_board.move!(piece.color, piece.pos, destination)
    !new_board.in_check?(piece.color)
  end

  def [](i, j)
    @matrix[i][j]
  end

  def []=(i, j, val)
    @matrix[i][j] = val
  end


  def move_within_bounds?(pos)
    pos.first.between?(0, @board_size - 1) \
      && pos.last.between?(0, @board_size - 1)
  end

  def empty_space?(pos)
    self[pos.first, pos.last].nil?
  end

  def in_check?(color)
    # find the king!
    king = King.new({})
    @matrix.each do |row|
      row.each do |piece|
        king = piece if piece.class == King && piece.color == color
      end
    end

    if color == "white"
      @black_pieces.any? { |piece| piece.moves.include?(king.pos) unless piece.moves.nil? }
    else
      @white_pieces.any? { |piece| piece.moves.include?(king.pos) unless piece.moves.nil? }
    end
  end


  protected


  def dup
    duped_board = Board.new
    @matrix.each_with_index do |row, i|
      row.each_with_index do |space, j|
        duped_board.matrix[i][j] = nil

        unless @matrix[i][j].nil?
          piece = Rook.new({}) if @matrix[i][j].class == Rook
          piece = Bishop.new({}) if @matrix[i][j].class == Bishop
          piece = Queen.new({}) if @matrix[i][j].class == Queen
          piece = King.new({}) if @matrix[i][j].class == King
          piece = Knight.new({}) if @matrix[i][j].class == Knight
          piece = Pawn.new({}) if @matrix[i][j].class == Pawn
          piece.pos = @matrix[i][j].pos.dup
          piece.color = @matrix[i][j].color
          piece.display_char = @matrix[i][j].display_char
          piece.board = duped_board
          duped_board.matrix[i][j] = piece
          duped_board.white_pieces << piece if piece.color == "white"
          duped_board.black_pieces << piece if piece.color == "black"
        end
      end
    end
    duped_board
  end

  def move!(color, origin, destination)
    #move method without checking valid_move? to stop infinite loop
    raise ArgumentError.new "POSITION IS EMPTY" if @matrix[origin.first][origin.last].nil?
    piece = @matrix[origin.first][origin.last]
    raise ArgumentError.new "INVALID MOVE" if !check_move?(piece, destination)
    @matrix[destination.first][destination.last] = piece
    piece.pos = [destination.first, destination.last]
    @matrix[origin.first][origin.last] = nil
  end

  def test_pieces
    [0, 7].each do |row|
      color = "white" if row == 0
      color = "black" if row == 7

      option = {:color => "white", :display_char => "Rk",:board => self, \
        :pos => [3, 4]}
      @test_piece = Rook.new(option)
      @matrix[3][4] = @test_piece

      option = {:color => "black", :display_char => "Rk",:board => self, \
        :pos => [0, 0]}
      @test_piece = Rook.new(option)
      @matrix[0][0] = @test_piece

      option = {:color => "white", :display_char => "Kn",:board => self, \
        :pos => [4, 4]}
      @test_piece = King.new(option)
      @matrix[4][4] = @test_piece

      option = {:color => "black", :display_char => "Qn",:board => self, \
        :pos => [5, 1]}
      @test_piece = Queen.new(option)
      @matrix[5][1] = @test_piece
    end

    @matrix.each do |row|
      row.each do |square|
        @white_pieces << square if !square.nil? && square.color == "white"
        @black_pieces << square if !square.nil? && square.color == "black"
      end
    end
  end

  def print_color
    display_array = Array.new(8) { Array.new(8) }
    @matrix.each_with_index do |row, i|
      row.each_with_index do |col, j|
        display_array[i][j] = @matrix[i][j].color unless @matrix[i][j].nil?
      end
    end
    display_array.each { |row| p row }
  end

  def print_moves
    p "TEST MOVES"
    display_array = Array.new(8) { Array.new(8) }
    @test_piece.moves.each do |coord|
      display_array[coord.first][coord.last] = "O"
    end
    display_array[@test_piece.pos.first][@test_piece.pos.last] = "Ts"
    display_array.each { |row| p row }
  end
end