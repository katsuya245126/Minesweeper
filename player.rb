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

  def parse_coordinate(string)
    string.split(',').map { |ele| Integer(ele) }
  end

  def prompt_coordinate_message
    print 'Input a coordinate(i.e 3,4): '
  end

  def prompt_command_message
    print 'Reveal(r) or Flag(f): '
  end
end
