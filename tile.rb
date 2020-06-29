require 'colorize'

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

  def toggle_flag
    @flagged = !@flagged
  end

  def to_s
    if flagged?
      'F'.colorize(:red)
    elsif revealed?
      return 'B'.colorize(:red) if bomb?

      neighbor_bombs != 0 ? colorize_bomb_count(neighbor_bombs) : ' '
    else
      '*'
    end
  end

  private

  attr_reader :bomb, :flagged, :revealed

  def colorize_bomb_count(count)
    case count
    when 1 then count.to_s.colorize(:blue)
    when 2 then count.to_s.colorize(:green)
    when 3 then count.to_s.colorize(:magenta)
    when 4 then count.to_s.colorize(:cyan)
    end
  end
end
