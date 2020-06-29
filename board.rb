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

  def initialize
    create_board
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

  def flag(pos)
    get_tile(pos).toggle_flag
  end

  def reveal(pos)
    return ArgumentError unless valid_pos?(pos)

    reveal_bomb?(pos) ? false : reveal_algorithm(pos)
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

  def reveal_algorithm(current_pos)
    current_tile = get_tile(current_pos)
    current_tile.reveal
    return true if current_tile.neighbor_bombs.positive?

    reveal_neighbor(current_pos)
    revealable = further_revealable_neighbors(current_pos)
    return if revealable.empty?

    revealable.each { |pos| reveal_algorithm(pos) }
    true
  end

  def reveal_bomb?(pos)
    if get_tile(pos).bomb?
      get_tile(pos).reveal
      true
    else
      false
    end
  end

  def reveal_tile(pos)
    tile = get_tile(pos)
    tile.reveal unless tile.bomb?
  end

  def further_revealable_tile?(pos)
    return false if get_tile(pos).neighbor_bombs.positive?

    neighbor_idx = neighbor_index(pos)

    neighbor_idx.any? do |current_pos|
      tile = get_tile(current_pos)
      !tile.bomb? && !tile.revealed?
    end
  end

  def reveal_neighbor(pos)
    neighbor_idx = neighbor_index(pos)

    neighbor_idx.each { |position| reveal_tile(position) }
  end

  def further_revealable_neighbors(pos)
    neighbor_idx = neighbor_index(pos)

    neighbor_idx.select { |current_pos| further_revealable_tile?(current_pos) }
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

  def create_empty_board
    board = Array.new(9) { [] }
    board.each do |row|
      9.times do
        row << Tile.new(false)
      end
    end
    board
  end

  def create_board
    empty_board = create_empty_board
    @board = place_bomb(empty_board)
    set_bomb_counts
  end
end
