class Computer
  attr_reader :memory

  def initialize
    @memory = nil
    @ip = 0
    @stdin_r, @stdin_w = IO.pipe
    @stdout_r = nil
    @stdout_w = nil
  end

  def execute(intcode)
    @memory = intcode.dup
    @ip = 0
    @stdout_r, @stdout_w = IO.pipe
    params = nil
    while @ip.between?(0, @memory.length - 1)
      opint = @memory[@ip]
      opcode = opint % 100
      modeint = opint / 100
      case opcode
      when 1 then op_add(modeint)
      when 2 then op_mul(modeint)
      when 3 then op_input(modeint)
      when 4 then op_output(modeint)
      when 5 then op_jit(modeint)
      when 6 then op_jif(modeint)
      when 7 then op_lt(modeint)
      when 8 then op_eq(modeint)
      when 99
        @stdout_w.close
        break
      else
        raise "Unknown opcode #{opcode}!"
      end
    end
    self
  end

  def stdin
    @stdin_w
  end

  def stdout
    @stdout_r
  end

  private

  def value(modeint, num)
    modes = modeint.to_s.rjust(3, '0').reverse.chars.map(&:to_i)
    param = @memory[@ip + num + 1]
    if modes[num] == 0
      @memory[param]
    else
      param
    end
  end

  def op_add(modeint)
    dest = @memory[@ip + 3]
    @memory[dest] = value(modeint, 0) + value(modeint, 1)
    @ip += 4
  end

  def op_mul(modeint)
    dest = @memory[@ip + 3]
    @memory[dest] = value(modeint, 0) * value(modeint, 1)
    @ip += 4
  end

  def op_input(_modeint)
    dest = @memory[@ip + 1]
    @memory[dest] = @stdin_r.gets.chomp.to_i
    @ip += 2
  end

  def op_output(_modeint)
    src = @memory[@ip + 1]
    @stdout_w.write(@memory[src].to_s + "\n")
    @ip += 2
  end

  def op_jit(modeint)
    if value(modeint, 0).zero?
      @ip += 3
    else
      @ip = value(modeint, 1)
    end
  end

  def op_jif(modeint)
    if value(modeint, 0).zero?
      @ip = value(modeint, 1)
    else
      @ip += 3
    end
  end

  def op_lt(modeint)
    dest = @memory[@ip + 3]
    @memory[dest] = value(modeint, 0) < value(modeint, 1) ? 1 : 0
    @ip += 4
  end

  def op_eq(modeint)
    dest = @memory[@ip + 3]
    @memory[dest] = value(modeint, 0) == value(modeint, 1) ? 1 : 0
    @ip += 4
  end
end
