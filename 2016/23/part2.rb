#!/usr/bin/env ruby

require_relative 'computer'

NBR_EGGS = 12

program = ARGF.readlines.map { |l| l.chomp.split }
computer = Computer.new(a: NBR_EGGS)
computer.execute(program)
puts computer.registers['a']
