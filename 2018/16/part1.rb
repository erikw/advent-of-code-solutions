#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

total_behaving = 0
while !ARGF.eof? && (before = ARGF.readline.chomp.split(': '))[0] == 'Before'
  before = before[1].scan(/\d+/).map(&:to_i)
  instruction = ARGF.readline.scan(/\d+/).map(&:to_i)
  after = ARGF.readline.scan(/\d+/).map(&:to_i)
  ARGF.readline

  computer = Computer.new
  behaving = Computer::OPCODES.times.count do |opcode|
    program = [[opcode] + instruction[1..]]
    computer.registers.replace(before)
    computer.execute(program).registers == after
  end
  total_behaving += 1 if behaving >= 3
end
puts total_behaving
