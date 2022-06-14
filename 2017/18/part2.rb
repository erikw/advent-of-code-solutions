#!/usr/bin/env ruby

class Computer
  attr_reader :registers

  def initialize(thread, que_rcv, que_snd, instructions)
    @thread = thread
    @registers = Hash.new(0).tap do |h|
      h['p'] = thread
      h['waiting'] = false
      h['sent'] = 0
    end
    @que_rcv = que_rcv
    @que_snd = que_snd
    @instructions = instructions
    @pc = 0
  end

  def execute
    return unless @pc.between?(0, @instructions.length - 1)

    case @instructions[@pc]
    in ['snd', x]
      @que_snd << value(x)
      @registers['sent'] += 1
      @pc += 1
    in ['set', x, y]
      @registers[x] = value(y)
      @pc += 1
    in ['add', x, y]
      @registers[x] += value(y)
      @pc += 1
    in ['mul', x, y]
      @registers[x] *= value(y)
      @pc += 1
    in ['mod', x, y]
      @registers[x] %= value(y)
      @pc += 1
    in ['jgz', x, y]
      @pc += value(x) > 0 ? value(y) : 1
    in ['rcv', x]
      if @que_rcv.empty?
        @registers['waiting'] = true
        return
      else
        @registers[x] = @que_rcv.pop
        @registers['waiting'] = false
        @pc += 1
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
end

instructions = ARGF.readlines.map { |l| l.chomp.split }
ques = 2.times.map { Thread::Queue.new }
prog0 = Computer.new(0, ques[0], ques[1], instructions)
prog1 = Computer.new(1, ques[1], ques[0], instructions)

until prog0.registers['waiting'] && prog1.registers['waiting']
  prog0.execute
  prog1.execute
end

puts prog1.registers['sent']
