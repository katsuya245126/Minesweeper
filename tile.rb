class Tile
  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
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
    elsif !revealed?
      '*'
    else
      ' '
    end
  end

  private

  attr_reader :bomb, :flagged, :revealed
end
