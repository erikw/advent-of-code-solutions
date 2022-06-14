class Computer
  attr_reader :registers

  def initialize(registers = { 'a' => 0, 'b' => 0 })
    @registers = registers
  end

  def execute(program)
    pc = 0
    while pc.between?(0, program.length - 1)
      case program[pc]
      in ['hlf', String => reg]
        @registers[reg] /= 2
        pc += 1
      in ['tpl', String => reg]
        @registers[reg] *= 3
        pc += 1
      in ['inc', String => reg]
        @registers[reg] += 1
        pc += 1
      in ['jmp', String => offset]
        pc += offset.to_i
      in ['jie', String => reg, String => offset]
        pc += @registers[reg].even? ? offset.to_i : 1
      in ['jio', String => reg, String => offset]
        pc += @registers[reg] == 1 ? offset.to_i : 1
      else
        pc = -1
      end
    end
    self
  end
end
