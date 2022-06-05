class Computer
  attr_accessor :registers

  def initialize
    @registers = { 'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0 }
  end

  def execute(program)
    i = 0
    while i.between?(0, program.length - 1)
      case program[i]
      in ['cpy', x, y]
        @registers[y] = value(x)
        i += 1
      in ['inc', x]
        @registers[x] += 1
        i += 1
      in ['dec', x]
        @registers[x] -= 1
        i += 1
      in ['jnz', x, y]
        i += value(x).zero? ? 1 : value(y)
      end
    end
  end

  private

  def value(x)
    x.match?(/-?\d+/) ? x.to_i : @registers[x]
  end
end
