#!/usr/bin/env ruby

require_relative 'lib'

GENERATIONS = 20

pots, states = read_input
GENERATIONS.times { pots = next_generation(states, pots) }
puts pots_sum(pots)
