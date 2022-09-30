require 'set'

class Computer
  attr_reader :memory

  STATUS_DONE = 0
  STATUS_INFLOOP = 1

  def execute(program)
    reset
    while @ip.between?(0, program.length - 1)
      return STATUS_INFLOOP if @executed.include?(@ip)

      @executed << @ip
      case program[@ip]
      in ['acc', amount]
        instr_acc(amount.to_i)
      in ['jmp', dist]
        instr_jmp(dist.to_i)
      in ['nop', x]
        instr_nop
      else
        raise "Unknown instruction: #{program[@ip]}"
      end
    end
    STATUS_DONE
  end

  private

  def reset
    @memory = Hash.new(0)
    @memory[:acc] = 0
    @ip = 0
    @executed = Set.new
  end

  def instr_acc(amount)
    @memory[:acc] += amount
    @ip += 1
  end

  def instr_jmp(dist)
    @ip += dist
  end

  def instr_nop
    @ip += 1
  end
end
