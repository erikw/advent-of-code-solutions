#!/usr/bin/env ruby
# frozen_string_literal: true

# Algorithm
# 1. Recursively discover the whole reachable map
#   * Backtrack when recursion returns to step the robot back to the original position.
# 2. Run Dijkstra on the map from origin to the found oxysys in previous system
#   * No need for the intcomputer anymore in this step.

require_relative 'lib'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

map = Hash.new(SYM_UNKNOWN) # Complex coord => symbol
map[POS_START] = SYM_OPEN

explore(map, computer, POS_START)
# print_map(map, POS_START)
pos_oxysys = map.select { |_k, v| v == SYM_OXYSYS }.keys.first
dist, _prev = dijkstra(map, POS_START, pos_oxysys)
puts dist[pos_oxysys]
