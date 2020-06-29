require_relative 'board.rb'
require_relative 'player.rb'

# Main
class Minesweeper
  def initialize
    @board = Board.new
    @player = Player.new
  end

  def run
    until board.win?
      refresh

      input = prompt_user

      board.reveal(input)
    end
  end

  private

  attr_reader :board, :player

  def prompt_user
    input = nil

    until valid_pos?(input)
      begin
        input = player.prompt
      rescue ArgumentError
        input_error
      else
        input_error unless valid_pos?(input)
      end
      refresh
    end

    input
  end

  def input_error
    puts 'Invalid input! Make sure to enter two digits between 0-8 with a comma in-between.'
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
