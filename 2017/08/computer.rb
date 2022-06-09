class Computer
  attr_reader :registers, :max_seen

  def initialize
    @registers = Hash.new(0)
    @max_seen = -Float::INFINITY
  end

  def execute(program)
    i = 0
    while i.between?(0, program.length - 1)
      case program[i]
      when /(\w+) (inc|dec) (-?\d+) if (\w+) ([<>]=?|[!=]=) (-?\d+)/
        reg = Regexp.last_match(1)
        op = Regexp.last_match(2)
        amount = Regexp.last_match(3).to_i
        cond_reg = Regexp.last_match(4)
        cond_op = Regexp.last_match(5)
        cond_val = Regexp.last_match(6).to_i
        increment(reg, op, amount, cond_reg, cond_op, cond_val)
      end
      i += 1
    end

    self
  end

  private

  def increment(reg, op, amount, cond_reg, cond_op, cond_val)
    if @registers[cond_reg].send(cond_op, cond_val)
      @registers[reg] += (op == 'inc' ? 1 : -1) * amount
      @max_seen = [@max_seen, @registers[reg]].max
    end
  end
end
