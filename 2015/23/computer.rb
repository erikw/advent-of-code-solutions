class Computer
  attr_reader :registers

  def initialize(registers={ "a" => 0, "b" =>  0 })
    @registers = registers
  end

  def execute(program)
    i = 0
    while i.between?(0, program.length-1)
      case program[i]
        in ["hlf", String => reg]
          @registers[reg] /= 2
          i += 1
        in ["tpl", String => reg]
          @registers[reg] *= 3
          i += 1
        in ["inc", String => reg]
          @registers[reg] += 1
          i += 1
        in ["jmp", String => offset]
          i += offset.to_i
        in ["jie", String => reg, String => offset]
          i += @registers[reg] % 2 == 0 ? offset.to_i : 1
        in ["jio", String => reg, String => offset]
          i += @registers[reg] == 1 ? offset.to_i : 1
      else
        i = -1
      end
    end
    self
  end
end
