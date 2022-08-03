#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

intcode = ARGF.readline.split(',').map(&:to_i)

computer = Computer.new
computer.stdin << 1
computer.execute(intcode)

output = []
output << computer.stdout.pop until computer.stdout.empty?
puts output.join(',')
