#!/usr/bin/env ruby

class Computer
  attr_reader :registers, :recovered

  def initialize
    @registers = Hash.new(0)
    @last_played = nil
    @recovered = nil
  end

  def execute(program)
    pc = 0
    while pc.between?(0, program.length - 1)
      # puts "pc=#{pc}, regs: #{@registers.inspect}, inst: #{program[pc]}"
      case program[pc]
      in ['snd', x]
        @last_played = value(x)
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
      in ['rcv', x]
        unless value(x).zero?
          @recovered = @last_played
          break
        end
        pc += 1
      in ['jgz', x, y]
        pc += value(x) > 0 ? value(y) : 1
      end
    end
    self
  end

  private

  def match_digits(str)
    str.match?(/-?\d+/)
  end

  def value(x)
    match_digits(x) ? x.to_i : @registers[x]
  end
end

program = ARGF.readlines.map { |l| l.chomp.split }
puts Computer.new.execute(program).recovered
