class Tile
  attr_accessor :neighbor_bombs

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
    @neighbor_bombs = 0
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
      return 'B' if bomb?

      neighbor_bombs != 0 ? neighbor_bombs.to_s : ' '
    else
      '*'
    end
  end

  private

  attr_reader :bomb, :flagged, :revealed
end
