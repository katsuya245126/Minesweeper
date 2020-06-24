require_relative 'tile.rb'

class Board
  def self.empty_board
    board = Array.new(9) { [] }
    board.each do |row|
      9.times do
        row << Tile.new(false)
      end
    end
    board
  end

  def initialize
    @board = place_bomb(Board.empty_board)
  end

  def place_bomb(board, num = 9)
    remaining_bombs = num
    bombed_board = board

    until remaining_bombs.zero?
      y = rand(0..8)
      x = rand(0..8)
      next if board[y][x].bomb?

      board[y][x] = Tile.new(true)
      remaining_bombs -= 1
    end

    bombed_board
  end

  def render
    puts
    puts "  #{(0..8).to_a.join("  ")}"
    board.each_with_index do |row, idx|
      print "#{idx}"
      row.each do |tile|
        print " #{tile} "
      end
      puts
    end
    puts
  end

  private

  attr_reader :board
end
