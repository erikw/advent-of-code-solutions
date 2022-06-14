class Computer
  attr_reader :registers

  def initialize(a: 0, b: 0, c: 0, d: 0)
    @registers = { 'a' => a, 'b' => b, 'c' => c, 'd' => d }
  end

  def execute(program)
    pc = 0
    while pc.between?(0, program.length - 1)
      case program[pc]
      in ['cpy', x, y]
        continue if match_digits(y)
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
      in ['tgl', x]
        toggle(program, pc + value(x))
        pc += 1
      in ['mul', x, y, z]
        @registers[x] = value(y) * value(z)
        pc += 1
      in ['out', x]
        puts value(x)
        pc += 1
      end
    end
  end

  private

  def match_digits(str)
    str.match?(/-?\d+/)
  end

  def value(x)
    match_digits(x) ? x.to_i : @registers[x]
  end

  def toggle(program, pc)
    return unless pc.between?(0, program.length - 1)

    program[pc][0] = if program[pc].length == 2
                       program[pc][0] == 'inc' ? 'dec' : 'inc'
                     elsif program[pc].length == 3
                       program[pc][0] == 'jnz' ? 'cpy' : 'jnz'
                     end
  end
end
