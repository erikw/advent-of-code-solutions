class Computer
  attr_reader :registers

  def initialize(registers = [0, 0, 0, 0, 0, 0])
    @registers = registers[...6]
    @ip = 0
    @ip_register = 0
  end

  def execute(instructions)
    @ip = 0
    @ip_register = instructions.shift[1].to_i
    while @ip.between?(0, instructions.length - 1)
      # puts "[#{@ip}] #{instructions[@ip].join(' ')}"
      instruction = instructions[@ip][0]
      a, b, c = instructions[@ip][1..3].map(&:to_i)
      @registers[@ip_register] = @ip
      case instruction
      when 'addr' then op_addr(a, b, c)
      when 'addi' then op_addi(a, b, c)
      when 'mulr' then op_mulr(a, b, c)
      when 'muli' then op_muli(a, b, c)
      when 'banr' then op_banr(a, b, c)
      when 'bani' then op_bani(a, b, c)
      when 'borr' then op_borr(a, b, c)
      when 'bori' then op_bori(a, b, c)
      when 'setr' then op_setr(a, b, c)
      when 'seti' then op_seti(a, b, c)
      when 'gtir' then op_gtir(a, b, c)
      when 'gtri' then op_gtri(a, b, c)
      when 'gtrr' then op_gtrr(a, b, c)
      when 'eqir' then op_eqir(a, b, c)
      when 'eqri' then op_eqri(a, b, c)
      when 'eqrr' then op_eqrr(a, b, c)
      end
      @ip = @registers[@ip_register]
      @ip += 1
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
