require_relative 'board.rb'
require_relative 'player.rb'

# Main
class Minesweeper
  def initialize
    @board = Board.new
    @player = Player.new
  end

  def run
    until board.win? || board.lost?
      refresh
      command = prompt_user_command
      input = prompt_user_coordinate

      case command
      when 'r' then board.reveal(input)
      when 'f' then board.flag(input)
      end
    end

    refresh
    board.win? ? win_message : loss_message
  end

  private

  attr_reader :board, :player

  def prompt_user_coordinate
    input = nil

    loop do
      begin
        input = player.prompt_coordinate
      rescue ArgumentError
        nil
      end
      break if valid_pos?(input)

      coordinate_error
      refresh
    end

    input
  end

  def prompt_user_command
    command = nil

    loop do
      command = player.prompt_command
      break if valid_command?(command)

      command_error
      refresh
    end

    command
  end

  def coordinate_error
    puts 'Invalid input! Make sure to enter two digits between 0-8 with a comma in-between.'
    print 'Press Enter to continue...'
    gets
  end

  def command_error
    puts 'Invalid command! Type f to flag and r to reveal!'
    print 'Press Enter to continue...'
    gets
  end

  def valid_pos?(pos)
    pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |i| i.between?(0, 8) }
  end

  def valid_command?(command)
    command.is_a?(String) &&
      command.length == 1 &&
      (command == 'f' || command == 'r')
  end

  def win_message
    puts 'You win!'
  end

  def loss_message
    puts 'You revealed a bomb! You lose!'
  end

  def refresh
    system('clear')
    board.render
  end
end
