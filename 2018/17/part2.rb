#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

map = read_map
ymax = map.keys.map(&:last).max
flow = nil
flow = drop_water(map, *WATER_SRC_CORD, ymax) until flow == :flow_inf

puts map.values.count { |s| [SYM_WATER_REST].include?(s) }
