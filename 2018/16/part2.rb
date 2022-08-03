#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'
require 'set'

behaving = Hash.new { |h, k| h[k] = Set.new }
while !ARGF.eof? && (before = ARGF.readline.chomp.split(': '))[0] == 'Before'
  before = before[1].scan(/\d+/).map(&:to_i)
  instruction = ARGF.readline.scan(/\d+/).map(&:to_i)
  after = ARGF.readline.scan(/\d+/).map(&:to_i)
  ARGF.readline

  computer = Computer.new
  Computer::OPCODES.times.count do |opcode|
    program = [[opcode] + instruction[1..]]
    computer.registers.replace(before)
    behaving[instruction[0]] << opcode if computer.execute(program).registers == after
  end
end

mapping = {}
until mapping.length == Computer::OPCODES
  newly_mapped = Set.new
  behaving.each do |opcode, matching_ops|
    if matching_ops.length == 1
      mapping[opcode] = matching_ops.first
      newly_mapped << mapping[opcode]
    end
  end
  (behaving.keys - mapping.keys).each do |opcode|
    behaving[opcode] -= newly_mapped
  end
end

ARGF.readline
ARGF.readline

instructions = ARGF.each_line.map { |l| l.split.map(&:to_i) }
puts Computer.new(mapping:).execute(instructions).registers[0]
