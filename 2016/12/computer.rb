class Computer
  attr_accessor :registers

  def initialize(a: 0, b: 0, c: 0, d: 0)
    @registers = { 'a' => a, 'b' => b, 'c' => c, 'd' => d }
  end

  def execute(program)
    pc = 0
    while pc.between?(0, program.length - 1)
      case program[pc]
      in ['cpy', x, y]
        @registers[y] = value(x)
        pc += 1
      in ['inc', x]
        @registers[x] += 1
        pc += 1
      in ['dec', x]
        @registers[x] -= 1
        pc += 1
      in ['jnz', x, y]
        pc += value(x).zero? ? 1 : value(y)
      end
    end
  end

  private

  def value(x)
    x.match?(/-?\d+/) ? x.to_i : @registers[x]
  end
end
