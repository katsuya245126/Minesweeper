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
    set_bomb_counts
  end

  def get_tile(pos)
    y, x = pos
    board[y][x]
  end

  def render
    line = '  ------------------------------------'
    puts "\n   #{(0..8).to_a.join('   ')}\n#{line}\n"
    board.each_with_index do |row, idx|
      print idx.to_s
      row.each do |tile|
        print "| #{tile} "
      end
      print "|\n#{line}\n"
    end
    puts
  end

  def reveal(my_pos)
    return false if get_tile(my_pos).bomb?
    return true if neighbor_tiles(my_pos).all? { |tile| tile.revealed? || tile.bomb? }

    get_tile(my_pos).reveal
    clean_squares = []
    neighbor_idx = neighbor_index(my_pos)

    neighbor_idx.each do |pos|
      tile = get_tile(pos)
      tile.reveal unless tile.bomb?
      clean_squares << pos if clean_square?(tile)
    end

    clean_squares.all? { |pos| reveal(pos) }
  end

  def win?
    board.all? do |row|
      row.all? { |tile| tile.revealed? || tile.bomb? }
    end
  end

  def lost?
    board.any? do |row|
      row.any? { |tile| tile.bomb? && tile.revealed? }
    end
  end

  private

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

  def set_bomb_counts
    board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        tile.neighbor_bombs = neighbor_bomb_count([y, x])
      end
    end
  end

  def neighbor_bomb_count(my_pos)
    neighbor_idx = neighbor_index(my_pos)
    bomb_count = 0

    neighbor_idx.each do |pos|
      y, x = pos
      bomb_count += 1 if board[y][x].bomb?
    end

    bomb_count
  end

  def neighbor_tiles(my_pos)
    neighbor_idx = neighbor_index(my_pos)

    neighbor_idx.map do |pos|
      y, x = pos
      board[y][x]
    end
  end

  def neighbor_index(my_pos)
    neighbor_idx = NEIGHBOR_POS.dup.map do |pos|
      y, x = pos
      my_y, my_x = my_pos
      [y + my_y, x + my_x]
    end

    neighbor_idx.select { |pos| valid_pos?(pos) }
  end

  def valid_pos?(pos)
    y, x = pos
    y.between?(0, 8) && x.between?(0, 8)
  end

  def clean_square?(tile)
    tile.to_s == ' '
  end
end
