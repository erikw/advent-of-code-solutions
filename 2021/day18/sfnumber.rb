class String
  def to_sfnumber
    stack = []
    each_char do |c|
      case c
      when /\d+/
        stack << c.to_i
      when ']'
        right = stack.pop
        left = stack.pop
        stack << [left, right]
      end
    end
    SFNumber.new(stack.pop)
  end
end

class SFNumber
  def initialize(data)
    @data = data
    reduce
  end

  def to_s
    repr(@data)
  end
  alias inspect to_s

  def +(other)
    data_lhs = Marshal.load(Marshal.dump(@data))
    data_rhs = Marshal.load(Marshal.dump(other.data))
    SFNumber.new([data_lhs, data_rhs])
  end

  def magnitude
    calc_magnitude(@data)
  end

  protected

  attr_reader :data

  private

  def push_carry(data, direction, carry)
    if data.is_a? Array
      if direction == :left
        data[0] = push_carry(data[0], direction, carry)
      else
        data[1] = push_carry(data[1], direction, carry)
      end
      data
    else
      data + carry
    end
  end

  def reduce_explode(data, depth)
    case data
    when Array
      if depth == 4
        [0, data[0], data[1], true]
      else
        data[0], carry_left1, carry_right1, changed1 = reduce_explode(data[0], depth + 1)
        if changed1
          data[1] = push_carry(data[1], :left, carry_right1)
          return [data, carry_left1, 0, true]
        end

        data[1], carry_left2, carry_right2, changed2 = reduce_explode(data[1], depth + 1)
        if changed2
          data[0] = push_carry(data[0], :right, carry_left2)
          return [data, 0, carry_right2, true]
        end

        [data, 0, 0, false]
      end
    when Integer
      [data, 0, 0, false]
    end
  end

  def reduce_split(data)
    case data
    when Array
      data[0], changed1 = reduce_split(data[0])
      return [data, true] if changed1

      data[1], changed2 = reduce_split(data[1])
      [data, changed2]
    when Integer
      if data >= 10
        [[data / 2, (data / 2.0).ceil], true]
      else
        [data, false]
      end
    end
  end

  def reduce
    loop do
      @data, _, _, changed = reduce_explode(@data, 0)
      @data, changed = reduce_split(@data) unless changed
      break unless changed
    end
  end

  def calc_magnitude(data)
    case data
    when Array
      3 * calc_magnitude(data[0]) + 2 * calc_magnitude(data[1])
    when Integer
      data
    end
  end

  def repr(data)
    case data
    when Array
      lhs = repr(data[0])
      rhs = repr(data[1])
      "[#{lhs},#{rhs}]"
    when Integer
      data.to_s
    end
  end
end
