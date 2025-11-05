#!/usr/bin/env ruby
# frozen_string_literal: true

# Obviously not working to brute-force, but by principle we should at least try to not miss an obvious solution...

require_relative 'computer'

in_reg, in_instr = ARGF.read.split("\n\n")
registers = in_reg.each_line.map { |l| l.split(':')[1].to_i }
instructions = in_instr.split(':')[1].split(',').map(&:to_i)

reg_a = -1
computer = Computer.new([reg_a, 0, 0])
loop do
  reg_a += 1
  computer.registers[:A] = reg_a
  # puts "Executing with registers[:A]=#{computer.registers[:A]}"

  computer.execute(instructions)
  output = computer.stdout.size.times.map { computer.stdout.pop }

  break if output == instructions
end

puts reg_a
