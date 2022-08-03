#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

depth, target = read_input
erosions = erosion_levels(target, depth)
cave = types(erosions, target, depth)

# print_cave(erosions, target, depth)

total_risk_level = cave.values.sum
puts total_risk_level
