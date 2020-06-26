class Player
  def prompt
    prompt_message
    input = gets.chomp
    parse(input)
  end

  def parse(string)
    string.split(',').map { |ele| Integer(ele) }
  end

  def prompt_message
    print 'Input a coordinate(i.e 3,4): '
  end
end