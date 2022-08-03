#!/usr/bin/env ruby
# frozen_string_literal: true

class Gate
  attr_reader :output

  def initialize(output)
    @output = output
    @value = nil
  end

  def value
    @value ||= gen_value
  end
end

class BinaryGate < Gate
  attr_accessor :lhs, :rhs
end

class And < BinaryGate
  def gen_value
    @lhs.value & @rhs.value
  end
end

class Or < BinaryGate
  def gen_value
    @lhs.value | @rhs.value
  end
end

class LShift < BinaryGate
  def gen_value
    @lhs.value << @rhs.value
  end
end

class RShift < BinaryGate
  def gen_value
    @lhs.value >> @rhs.value
  end
end

class SingularGate < Gate
  attr_accessor :input
end

class Not < SingularGate
  def gen_value
    ~input.value & 0xFFFF
  end
end

class Nop < SingularGate
  def gen_value
    input.value
  end
end

class Literal < Gate
  attr_reader :value

  def initialize(output, value)
    super(output)
    @value = value
  end
end

wire2producer = {}

instructions = ARGF.each_line.map { |l| l.sub(/NOT/, '_ NOT').sub(/^\w+ ->/, '_ NOP \0').sub(/-> /, '').split }
instructions.each do |lhs, op, rhs, wire|
  gate = case op
         when 'AND' then And
         when 'OR' then Or
         when 'LSHIFT' then LShift
         when 'RSHIFT' then RShift
         when 'NOT' then Not
         when 'NOP' then Nop
         end.new(wire)
  wire2producer[wire] = gate

  wire2producer[lhs] = Literal.new(lhs, lhs.to_i) if lhs =~ /\d+/
  wire2producer[rhs] = Literal.new(rhs, rhs.to_i) if rhs =~ /\d+/
end

instructions.each do |lhs, op, rhs, wire|
  gate = wire2producer[wire]
  puts "No gate for #{wire}" if gate.nil?
  if %w[NOT NOP].include? op
    gate.input = wire2producer[rhs]
  else
    gate.lhs = wire2producer[lhs]
    gate.rhs = wire2producer[rhs]
  end
end

puts wire2producer['a'].value
