class Computer
  attr_accessor :stdin, :stdout
  attr_reader :memory

  MODE_POSITION = 0
  MODE_IMMEDIATE = 1
  MODE_RELATIVE = 2

  def initialize(stdin: Thread::Queue.new, stdout: Thread::Queue.new)
    @memory = nil
    @ip = 0
    @relative_base = 0
    @stdin = stdin
    @stdout = stdout
  end

  def execute(intcode)
    @memory = Hash.new(0)
    intcode.each_with_index do |intc, i|
      @memory[i] = intc
    end
    @ip = 0
    @relative_base = 0
    params = nil
    while @ip.between?(0, @memory.length - 1)
      opint = @memory[@ip]
      opcode = opint % 100
      modes = extract_modes(opint / 100)
      case opcode
      when 1 then op_add(modes)
      when 2 then op_mul(modes)
      when 3 then op_input(modes)
      when 4 then op_output(modes)
      when 5 then op_jit(modes)
      when 6 then op_jif(modes)
      when 7 then op_lt(modes)
      when 8 then op_eq(modes)
      when 9 then op_relbase(modes)
      when 99 then break
      else
        raise "Unknown opcode #{opcode}!"
      end
    end
    self
  end

  private

  def extract_modes(modeint)
    modes = modeint.to_s.rjust(3, '0').reverse.chars.map(&:to_i)
  end

  def value(modes, num)
    param = @memory[@ip + num + 1]
    case modes[num]
    when MODE_IMMEDIATE
      param
    when MODE_POSITION
      @memory[param]
    when MODE_RELATIVE
      @memory[@relative_base + param]
    end
  end

  def addr(modes, num)
    param = @memory[@ip + num + 1]
    case modes[num]
    when MODE_IMMEDIATE
      raise 'Non-supported address mode'
    when MODE_POSITION
      param
    when MODE_RELATIVE
      @relative_base + param
    end
  end

  def op_add(modes)
    dest = addr(modes, 2)
    @memory[dest] = value(modes, 0) + value(modes, 1)
    @ip += 4
  end

  def op_mul(modes)
    dest = addr(modes, 2)
    @memory[dest] = value(modes, 0) * value(modes, 1)
    @ip += 4
  end

  def op_input(modes)
    dest = addr(modes, 0)
    @memory[dest] = @stdin.pop
    @ip += 2
  end

  def op_output(modes)
    @stdout << value(modes, 0)
    @ip += 2
  end

  def op_jit(modes)
    if value(modes, 0).zero?
      @ip += 3
    else
      @ip = value(modes, 1)
    end
  end

  def op_jif(modes)
    if value(modes, 0).zero?
      @ip = value(modes, 1)
    else
      @ip += 3
    end
  end

  def op_lt(modes)
    dest = addr(modes, 2)
    @memory[dest] = value(modes, 0) < value(modes, 1) ? 1 : 0
    @ip += 4
  end

  def op_eq(modes)
    dest = addr(modes, 2)
    @memory[dest] = value(modes, 0) == value(modes, 1) ? 1 : 0
    @ip += 4
  end

  def op_relbase(modes)
    @relative_base += value(modes, 0)
    @ip += 2
  end
end
