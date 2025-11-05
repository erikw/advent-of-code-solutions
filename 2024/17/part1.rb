#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

in_reg, in_instr = ARGF.read.split("\n\n")
registers = in_reg.each_line.map { |l| l.split(':')[1].to_i }
instructions = in_instr.split(':')[1].split(',').map(&:to_i)

computer = Computer.new(registers)
computer.execute(instructions)

output = computer.stdout.size.times.map { computer.stdout.pop.to_s }.join(',')
puts output
