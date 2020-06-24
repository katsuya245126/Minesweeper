class Tile
  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
  end

  def bombed?
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

  private

  attr_reader :bomb, :flagged, :revealed
end