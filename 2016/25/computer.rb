class Computer
  attr_reader :registers

  def initialize(a: 0, b: 0, c: 0, d: 0)
    @registers = { 'a' => a, 'b' => b, 'c' => c, 'd' => d }
  end

  def execute(program)
    i = 0
    while i.between?(0, program.length - 1)
      case program[i]
      in ['cpy', x, y]
        continue if match_digits(y)
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
      in ['tgl', x]
        toggle(program, i + value(x))
        i += 1
      in ['mul', x, y, z]
        @registers[x] = value(y) * value(z)
        i += 1
      in ['out', x]
        puts value(x)
        i += 1
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

  def toggle(program, i)
    return unless i.between?(0, program.length - 1)

    program[i][0] = if program[i].length == 2
                      program[i][0] == 'inc' ? 'dec' : 'inc'
                    elsif program[i].length == 3
                      program[i][0] == 'jnz' ? 'cpy' : 'jnz'
                    end
  end
end
