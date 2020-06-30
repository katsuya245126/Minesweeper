require 'yaml'
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

      process_command(command)
    end

    refresh
    board.win? ? win_message : loss_message
  end

  private

  attr_reader :board, :player

  def process_command(command)
    case command
    when 'r'
      input = prompt_user_coordinate
      board.reveal(input)
    when 'f'
      input = prompt_user_coordinate
      board.flag(input)
    when 's' then save
    when 'l' then load
    when 'q' then quit
    end
  end

  def save
    file_name = player.prompt_file_name

    File.open("#{file_name}.yml", 'w') { |file| file.write(board.to_yaml) }
  end

  def load
    file_path = player.prompt_file_path

    @board = YAML.load(File.read(file_path))
  end

  def quit
    abort('Exiting program...')
  end

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
      %w[r f s l q].include?(command)
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
