require_relative 'tile.rb'

class Board
  NEIGHBOR_POS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ].freeze

  attr_reader :board

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

  def get_tile(pos)
    y, x = pos
    board[y][x]
  end

  def render
    puts
    puts "  #{(0..8).to_a.join('  ')}"
    board.each_with_index do |row, idx|
      print idx.to_s
      row.each do |tile|
        print " #{tile} "
      end
      puts
    end
    puts
  end

  def reveal(pos)
    nil
  end

  private

  def neighbor_bomb_count(my_pos)
    neighbor_idx = get_neighbor_idx(my_pos)
    bomb_count = 0

    neighbor_idx.each do |pos|
      y, x = pos
      bomb_count += 1 if board[y][x].bomb?
    end

    bomb_count
  end

  def get_neighbor_idx(my_pos)
    NEIGHBOR_POS.dup.map do |pos|
      y, x = pos
      my_y, my_x = my_pos
      [y + my_y, x + my_x]
    end
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

  
end
