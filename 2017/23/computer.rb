class Computer
  attr_reader :registers

  def initialize(**reginit)
    # @registers = Hash.new(0).merge(reginit.transform_keys(&:to_s))
    @registers = Hash.new(0).merge(reginit)
  end

  def execute(instructions)
    pc = 0
    while pc.between?(0, instructions.length - 1)
      case instructions[pc]
      in ['set', x, y]
        @registers[x] = value(y)
      in ['sub', x, y]
        @registers[x] -= value(y)
      in ['mul', x, y]
        @registers[x] *= value(y)
        @registers['muls'] += 1
      in ['jnz', x, y]
        pc += value(y) - 1 if value(x) != 0
      end
      pc += 1
    end

    self
  end

  private

  def match_digits(str)
    str.match?(/-?\d+/)
  end

  def value(x)
    match_digits(x) ? x.to_i : @registers[x]
  end
end
