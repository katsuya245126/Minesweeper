require_relative 'board.rb'
require_relative 'player.rb'

class Minesweeper
  def initialize
    @board = Board.new
    @player = Player.new
  end

  def run
    until board.win?
      refresh
      begin
        input = player.prompt
      rescue ArgumentError
        input_error
        next
      end

      break
    end
  end

  private

  attr_reader :board, :player

  def input_error
    puts 'Invalid input! Make sure to enter a digit between 0-8 with a comma between.'
    print 'Press Enter to continue...'
    gets
  end

  def valid_pos?(pos)
    pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |i| i.between?(0, 8) } &&
      !board.get_tile(pos).revealed?
  end

  def refresh
    system('clear')
    board.render
  end
end
