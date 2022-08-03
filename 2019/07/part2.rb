#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

NUM_AMPLIFIERS = 5
PHASE_RANGE = 5..9

intcode = ARGF.readline.split(',').map(&:to_i)

prev_stdout = nil
amplifiers = []
NUM_AMPLIFIERS.times do |_i|
  amplifiers << Computer.new(stdin: prev_stdout)
  prev_stdout = amplifiers.last.stdout
end
amplifiers[0].stdin = amplifiers[-1].stdout

highest = 0
PHASE_RANGE.to_a.permutation do |phases|
  (0...NUM_AMPLIFIERS).each do |i|
    amplifiers[i].stdin << phases[i]
  end
  amplifiers[0].stdin << 0
  threads = amplifiers.map do |amp|
    Thread.new do
      amp.execute(intcode)
    end
  end
  threads.each { |t| t.join }
  output = amplifiers.last.stdout.pop
  highest = [highest, output].max
end

puts highest
