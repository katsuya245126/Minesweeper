class Player
  def prompt_command
    prompt_command_message
    command = gets.chomp
    command
  end

  def prompt_coordinate
    prompt_coordinate_message
    input = gets.chomp
    parse_coordinate(input)
  end

  def prompt_file_name
    prompt_file_name_message
    input = gets.chomp
    input
  end

  def prompt_file_path
    prompt_file_path_message
    input = gets.chomp
    input
  end

  private

  def parse_coordinate(string)
    string.split(',').map { |ele| Integer(ele) }
  end

  def prompt_coordinate_message
    print 'Input a coordinate(i.e 3,4): '
  end

  def prompt_command_message
    puts 'Reveal(r) | Flag(f) | Save(s) | Load(l) | Quit(q)'
    print 'Enter a command: '
  end

  def prompt_file_name_message
    print 'Enter a name for save file: '
  end

  def prompt_file_path_message
    print 'Enter file path: '
  end
end
