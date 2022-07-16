#!/usr/bin/env ruby

require_relative 'computer_pipe'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
computer.stdin << "5\n"
computer.execute(intcode)
puts computer.stdout.readlines.last
