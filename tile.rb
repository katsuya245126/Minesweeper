class Tile
  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = true
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
      fringe != 0 ? fringe.to_s : '_'
    else
      '*'
    end
  end

  private

  attr_reader :bomb, :flagged, :revealed, :fringe
end
