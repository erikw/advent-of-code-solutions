#!/usr/bin/env ruby
# frozen_string_literal: true

# https://oeis.org/A016754
def odd_squares(n)
  (2 * n + 1)**2
end

square_data = ARGF.readline.to_i
if square_data == 1
  puts 0
  exit
end

# Explanation: https://mkst.github.io/aoc/tutorial/2017/12/27/aoc-day-03.html
ring = 0
ring += 1 while square_data > odd_squares(ring)

nums_in_ring = odd_squares(ring) - odd_squares(ring - 1)
nums_per_ring_side = nums_in_ring / 4
pos_in_ring = square_data - odd_squares(ring - 1)

other_dist =  ((pos_in_ring % nums_per_ring_side) - nums_per_ring_side / 2).abs

distance = ring + other_dist
puts distance
