# An Chronospatial Computer
class Computer
  OPS = {
    0 => :op_adv,
    1 => :op_bxl,
    2 => :op_bst,
    3 => :op_jnz,
    4 => :op_bxc,
    5 => :op_out,
    6 => :op_bdv,
    7 => :op_cdv
  }.freeze

  attr_accessor :registers
  attr_reader :stdout

  def initialize(registers = [0, 0, 0])
    raise ArgumentError, 'Wrong register data' unless registers.size == 3 && registers.all?(Integer)

    @registers = %i[A B C].zip(registers).to_h
    @ip = 0
    @instructions = nil
    @stdout = Thread::Queue.new
  end

  def execute(instructions)
    @stdout.clear
    @instructions = instructions
    @ip = 0

    while @ip < @instructions.size
      opcode = @instructions[@ip]
      method = OPS[opcode] or raise "Unknown opcode #{opcode}"
      send(method)
    end
  end

  private

  def op_adv
    @registers[:A] = reg_a_div
    @ip += 2
  end

  def op_bxl
    @registers[:B] ^= operand_literal
    @ip += 2
  end

  def op_bst
    @registers[:B] = operand_combo % 8
    @ip += 2
  end

  def op_jnz
    if @registers[:A].zero?
      @ip += 2
    else
      @ip = operand_literal
    end
  end

  def op_bxc
    @registers[:B] ^= @registers[:C]
    @ip += 2
  end

  def op_out
    @stdout << operand_combo % 8
    @ip += 2
  end

  def op_bdv
    @registers[:B] = reg_a_div
    @ip += 2
  end

  def op_cdv
    @registers[:C] = reg_a_div
    @ip += 2
  end

  def operand_literal
    @instructions.fetch(@ip + 1)
  end

  def operand_combo
    case (op = @instructions[@ip + 1])
    when 0..3 then op
    when 4 then @registers[:A]
    when 5 then @registers[:B]
    when 6 then @registers[:C]
    else raise "Invalid combo operand #{op}"
    end
  end

  def reg_a_div
    (@registers[:A] / 2**operand_combo).floor
  end
end
