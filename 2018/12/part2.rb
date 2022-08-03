#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

GENERATIONS = 50_000_000_000

pots, states = read_input
sums = [0, 0, 0]
gen = 0
loop do
  (sums << pots_sum(pots)).shift
  break if sums.each_cons(2).map { |a, b| b - a }.uniq.length == 1

  pots = next_generation(states, pots)
  gen += 1
end

final_sum = sums.last + (GENERATIONS - gen) * (sums[1] - sums[0])
puts final_sum
