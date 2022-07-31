class Computer
  attr_accessor :stdin, :stdout
  attr_reader :memory

  MODE_POSITION = 0
  MODE_IMMEDIATE = 1
  MODE_RELATIVE = 2

  STATUS_DONE = 0
  STATUS_INPUT_NEEDED = 1
  STATUS_OUTPUT = 3

  def initialize(intcode, stdin: Thread::Queue.new, stdout: Thread::Queue.new)
    @memory = intcode.each_with_index.to_a.map(&:reverse).to_h
    @memory.default = 0
    @ip = 0
    @relative_base = 0
    @stdin = stdin
    @stdout = stdout
  end

  def execute
    while @ip.between?(0, @memory.length - 1)
      opint = @memory[@ip]
      opcode = opint % 100
      @modes = extract_modes(opint / 100)
      case opcode
      when 1 then op_add
      when 2 then op_mul
      when 3
        return STATUS_INPUT_NEEDED if @stdin.empty?

        op_input
      when 4
        op_output
        return STATUS_OUTPUT
      when 5 then op_jit
      when 6 then op_jif
      when 7 then op_lt
      when 8 then op_eq
      when 9 then op_relbase
      when 99 then break
      else
        raise "Unknown opcode #{opcode}!"
      end
    end
    STATUS_DONE
  end

  private

  def extract_modes(modeint)
    modeint.to_s.rjust(3, '0').reverse.chars.map(&:to_i)
  end

  def value(num)
    param = @memory[@ip + num + 1]
    case @modes[num]
    when MODE_IMMEDIATE
      param
    when MODE_POSITION
      @memory[param]
    when MODE_RELATIVE
      @memory[@relative_base + param]
    end
  end

  def addr(num)
    param = @memory[@ip + num + 1]
    case @modes[num]
    when MODE_IMMEDIATE
      raise 'Non-supported address mode'
    when MODE_POSITION
      param
    when MODE_RELATIVE
      @relative_base + param
    end
  end

  def op_add
    dest = addr(2)
    @memory[dest] = value(0) + value(1)
    @ip += 4
  end

  def op_mul
    dest = addr(2)
    @memory[dest] = value(0) * value(1)
    @ip += 4
  end

  def op_input
    dest = addr(0)
    @memory[dest] = @stdin.pop
    @ip += 2
  end

  def op_output
    @stdout << value(0)
    @ip += 2
  end

  def op_jit
    if value(0).zero?
      @ip += 3
    else
      @ip = value(1)
    end
  end

  def op_jif
    if value(0).zero?
      @ip = value(1)
    else
      @ip += 3
    end
  end

  def op_lt
    dest = addr(2)
    @memory[dest] = value(0) < value(1) ? 1 : 0
    @ip += 4
  end

  def op_eq
    dest = addr(2)
    @memory[dest] = value(0) == value(1) ? 1 : 0
    @ip += 4
  end

  def op_relbase
    @relative_base += value(0)
    @ip += 2
  end
end
