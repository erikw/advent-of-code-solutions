IP_NOUN = 1
IP_VERB = 2

class Computer
  attr_reader :memory

  def initialize
    @memory = nil
  end

  def execute(intcode)
    @memory = intcode.dup
    ip = 0
    while ip.between?(0, @memory.length - 1)
      opcode = @memory[ip]
      params = @memory[ip + 1, 3]
      case opcode
      when 1 then op_add(*params)
      when 2 then op_mul(*params)
      when 99 then break
      else
        raise "Unknown opcode #{opcode}!"
      end
      ip += 4
    end
    self
  end

  private

  def op_add(a, b, c)
    @memory[c] = @memory[a] + @memory[b]
  end

  def op_mul(a, b, c)
    @memory[c] = @memory[a] * @memory[b]
  end
end
