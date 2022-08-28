#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'
require '../09/computer_iter'

VERBOSE = false

PROGRAM = <<~SPRINGSCRIPT
  NOT A J
  NOT B T
  OR T J
  NOT C T
  OR T J
  AND D J
SPRINGSCRIPT

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new(intcode)

run(computer)
read_print(computer, VERBOSE)

PROGRAM.each_line do |instruction|
  input(computer, instruction, VERBOSE)
end
input(computer, "WALK\n", VERBOSE)
run(computer)

read_print(computer, VERBOSE)
