#!/usr/bin/env ruby

require_relative 'computer'

instructions = ARGF.readlines.map { |l| l.chomp.split }
computer = Computer.new
puts computer.execute(instructions).registers['muls']
