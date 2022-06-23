class Computer
  attr_accessor :registers

  OPCODES = 16
  DEFAULT_OP_MAPPING = {
    0 => 0, 1 => 1, 2 => 2, 3 => 3,
    4 => 4, 5 => 5, 6 => 6, 7 => 7,
    8 => 8, 9 => 9, 10 => 10, 11 => 11,
    12 => 12, 13 => 13, 14 => 14, 15 => 15
  }

  def initialize(registers = [0, 0, 0, 0], mapping: nil)
    @registers = registers[...4]
    @mapping = mapping || DEFAULT_OP_MAPPING
  end

  def execute(program)
    pc = 0
    while pc.between?(0, program.length - 1)
      opcode, a, b, c = program[pc]
      case @mapping[opcode]
      when 0 then op_addr(a, b, c)
      when 1 then op_addi(a, b, c)
      when 2 then op_mulr(a, b, c)
      when 3 then op_muli(a, b, c)
      when 4 then op_banr(a, b, c)
      when 5 then op_bani(a, b, c)
      when 6 then op_borr(a, b, c)
      when 7 then op_bori(a, b, c)
      when 8 then op_setr(a, b, c)
      when 9 then op_seti(a, b, c)
      when 10 then op_gtir(a, b, c)
      when 11 then op_gtri(a, b, c)
      when 12 then op_gtrr(a, b, c)
      when 13 then op_eqir(a, b, c)
      when 14 then op_eqri(a, b, c)
      when 15 then op_eqrr(a, b, c)
      end
      pc += 1
    end
    self
  end

  private

  def op_addr(a, b, c)
    @registers[c] = @registers[a] + @registers[b]
  end

  def op_addi(a, b, c)
    @registers[c] = @registers[a] + b
  end

  def op_mulr(a, b, c)
    @registers[c] = @registers[a] * @registers[b]
  end

  def op_muli(a, b, c)
    @registers[c] = @registers[a] * b
  end

  def op_banr(a, b, c)
    @registers[c] = @registers[a] & @registers[b]
  end

  def op_bani(a, b, c)
    @registers[c] = @registers[a] & b
  end

  def op_borr(a, b, c)
    @registers[c] = @registers[a] | @registers[b]
  end

  def op_bori(a, b, c)
    @registers[c] = @registers[a] | b
  end

  def op_setr(a, _b, c)
    @registers[c] = @registers[a]
  end

  def op_seti(a, _b, c)
    @registers[c] = a
  end

  def op_gtir(a, b, c)
    @registers[c] = a > @registers[b] ? 1 : 0
  end

  def op_gtri(a, b, c)
    @registers[c] = @registers[a] > b ? 1 : 0
  end

  def op_gtrr(a, b, c)
    @registers[c] = @registers[a] > @registers[b] ? 1 : 0
  end

  def op_eqir(a, b, c)
    @registers[c] = a == @registers[b] ? 1 : 0
  end

  def op_eqri(a, b, c)
    @registers[c] = @registers[a]  == b ? 1 : 0
  end

  def op_eqrr(a, b, c)
    @registers[c] = @registers[a]  == @registers[b] ? 1 : 0
  end
end
