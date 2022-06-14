#!/usr/bin/env ruby

class Computer
  attr_reader :registers

  def initialize(thread, que_rcv, que_snd)
    @thread = thread
    @registers = Hash.new(0).tap do |h|
      h['p'] = thread
      h['sent'] = 0
    end
    @que_rcv = que_rcv
    @que_snd = que_snd
  end

  def execute(instructions)
    pc = 0
    while pc.between?(0, instructions.length - 1)
      case instructions[pc]
      in ['snd', x]
        @que_snd << value(x)
        @registers['sent'] += 1
        pc += 1
      in ['set', x, y]
        @registers[x] = value(y)
        pc += 1
      in ['add', x, y]
        @registers[x] += value(y)
        pc += 1
      in ['mul', x, y]
        @registers[x] *= value(y)
        pc += 1
      in ['mod', x, y]
        @registers[x] %= value(y)
        pc += 1
      in ['jgz', x, y]
        pc += value(x) > 0 ? value(y) : 1
      in ['rcv', x]
        # Should really work with num_waiting, and not que_snd.empty. However is not the case.
        # Both ques being empty does not necessarily mean deadlock, only if the other thread
        # would also do a pop, but could do snd which unblocks us.
        if @que_snd.num_waiting > 0 && @que_rcv.empty?
          # if @que_snd.empty? && @que_rcv.empty?
          @que_snd << :terminate
          return
        end
        rcvd = @que_rcv.pop
        return if rcvd == :terminate

        @registers[x] = rcvd
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
end

instructions = ARGF.readlines.map { |l| l.chomp.split }
ques = 2.times.map { Thread::Queue.new }
prog0 = Computer.new(0, ques[0], ques[1])
prog1 = Computer.new(1, ques[1], ques[0])
threads = []
threads << Thread.new { prog0.execute(instructions) }
threads << Thread.new { prog1.execute(instructions) }
threads.each { |thr| thr.join }
puts prog1.registers['sent']
