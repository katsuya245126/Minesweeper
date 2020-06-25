class Tile
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

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = true
    @fringe = 0
  end

  def bomb?
    bomb
  end

  def flagged?
    flagged
  end

  def revealed?
    revealed
  end

  def reveal
    @revealed = true
  end

  def to_s
    if flagged?
      'F'
    elsif revealed?
      fringe != 0 ? fringe.to_s : '_'
    else
      '*'
    end
  end

  def neighbor_bomb_count(board)
    my_pos = find_my_pos(board)
    neighbor_idx = get_neighbor_idx(my_pos)
    bomb_count = 0

    neighbor_idx.each { |pos| bomb_count += 1 if board.get_tile(pos).bomb? }

    @fringe = bomb_count
  end

  private

  attr_reader :bomb, :flagged, :revealed, :fringe

  def find_my_pos(board)
    board.board.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        return [y, x] if tile.object_id == self.object_id
      end
    end
  end

  def get_neighbor_idx(my_pos)
    NEIGHBOR_POS.dup.map do |pos|
      y, x = pos
      my_y, my_x = my_pos
      [y + my_y, x + my_x]
    end
  end
end
