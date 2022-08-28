#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'
require '../09/computer_iter'

VERBOSE = false

# Logical expression is (developed with logic.rb)
# (-A v -B v -C) ^ D ^ (H v E ^ I v E ^ F)
# which can be refactored to save on logical operators to
# -(A ^ B ^ C) ^ D ^ (H v E ^ (I v F))
# The expression is implemented from inside-to-out below:
PROGRAM = <<~SPRINGSCRIPT
  OR F T
  OR I T
  AND E T
  OR H J
  OR T J
  AND D J
  AND A T#{!'Reset T:=false by our current assumption to ABC=false' ? '' : ''}
  AND B T
  AND C T
  OR C T#{!'Now we can save C to T' ? '' : ''}
  AND B T
  AND A T
  NOT T T
  AND T J
SPRINGSCRIPT

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new(intcode)

run(computer)
read_print(computer, VERBOSE)

PROGRAM.each_line do |instruction|
  input(computer, instruction, VERBOSE)
end
input(computer, "RUN\n", VERBOSE)
run(computer)

read_print(computer, VERBOSE)
