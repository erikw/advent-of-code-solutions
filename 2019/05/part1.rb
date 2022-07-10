#!/usr/bin/env ruby

require_relative 'computer'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
computer.stdin << "1\n"
computer.execute(intcode)
puts computer.stdout.readlines.last
