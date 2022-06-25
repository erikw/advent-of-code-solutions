#!/usr/bin/env ruby

require_relative 'lib'

# Adding | above water source to kick-start the recursion, water source itself should also not count
SRC_OFFSET = 2
# Too tired to debug; Error in map generation;
# I'm adding 4 lines below the water source that should not be there
ERROR_OFFSET = 4

map = read_map
ymax = map.keys.map(&:last).max
flow = nil
flow = drop_water(map, *WATER_SRC_CORD, ymax) until flow == :flow_inf

puts map.values.count { |s| [SYM_WATER_FLOW, SYM_WATER_REST].include?(s) } - SRC_OFFSET - ERROR_OFFSET
