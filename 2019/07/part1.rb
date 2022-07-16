#!/usr/bin/env ruby

require_relative 'computer'

NUM_AMPLIFIERS = 5

intcode = ARGF.readline.split(',').map(&:to_i)
amplifiers = NUM_AMPLIFIERS.times.map { Computer.new }

highest = 0
(0...NUM_AMPLIFIERS).to_a.permutation do |phases|
  prev_output = 0
  (0...NUM_AMPLIFIERS).each do |i|
    amplifiers[i].stdin << phases[i]
    amplifiers[i].stdin << prev_output
    amplifiers[i].execute(intcode)
    prev_output = amplifiers[i].stdout.pop
  end
  highest = [highest, prev_output].max
end

puts highest
