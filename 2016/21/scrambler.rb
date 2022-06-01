class Scrambler
  def initialize(instructions)
    @instructions = parse_instructions(instructions)
    @string = nil
    @reverse = false
  end

  def scramble(string)
    @string = string.chars
    @reverse = false
    @instructions.each do |instruction|
      method = instruction[0]
      args = instruction[1..]
      send(method, *args)
    end
    @string.join
  end

  def unscramble(string)
    @string = string.chars
    @reverse = true
    @instructions.reverse_each do |instruction|
      method = instruction[0]
      args = instruction[1..]
      send(method, *args)
    end
    @string.join
  end

  private

  def parse_instructions(instructions)
    instructions.map do |instruction|
      case instruction
      when /swap position (\d+) with position (\d+)/
        from = Regexp.last_match(1).to_i
        to = Regexp.last_match(2).to_i
        [:swap_positions, from, to]
      when /swap letter (\w) with letter (\w)/
        x = Regexp.last_match(1)
        y = Regexp.last_match(2)
        [:swap_letters, x, y]
      when /reverse positions (\d+) through (\d+)/
        from = Regexp.last_match(1).to_i
        to = Regexp.last_match(2).to_i
        [:reverse, from, to]
      when /rotate (left|right) (\d+) step/
        direction = Regexp.last_match(1).to_sym
        steps = Regexp.last_match(2).to_i
        [:rotate, direction, steps]
      when /move position (\d+) to position (\d+)/
        from = Regexp.last_match(1).to_i
        to = Regexp.last_match(2).to_i
        [:move, from, to]
      when /rotate based on position of letter (\w)/
        letter = Regexp.last_match(1)
        [:rotate_from, letter]
      end
    end
  end

  def swap_positions(from, to)
    from, to = to, from if @reverse
    @string[from], @string[to] = @string[to], @string[from]
  end

  def swap_letters(x, y)
    x, y = y, x if @reverse
    @string.each_with_index do |c, i|
      if c == x
        @string[i] = y
      elsif c == y
        @string[i] = x
      end
    end
  end

  def reverse(from, to)
    @string[from..to] = @string[from..to].reverse
  end

  def rotate_internal(direction, steps)
    steps = steps % @string.length
    if direction == :left
      steps.times { @string << @string.shift }
    else
      steps.times { @string.unshift(@string.pop) }
    end
  end

  def rotate(direction, steps)
    if @reverse
      direction = direction == :left ? :right : :left
    end
    rotate_internal(direction, steps)
  end

  def move(from, to)
    from, to = to, from if @reverse
    letter = @string.delete_at(from)
    @string.insert(to, letter)
  end

  def rotate_from(letter)
    if @reverse
      rotate_internal(:left, 1)
      rotations = 0
      loop do
        idx = @string.index(letter)
        break if idx + (idx < 4 ? 0 : 1) == rotations

        rotate_internal(:left, 1)
        rotations += 1
      end
    else
      idx = @string.index(letter)
      steps = 1 + idx + (idx < 4 ? 0 : 1)
      rotate_internal(:right, steps)
    end
  end
end
