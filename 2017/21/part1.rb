#!/usr/bin/env ruby

require_relative 'lib'

# ITERATIONS = 2
ITERATIONS = 5

rules = parse_rules(ARGF)
image = enhance_image(IMAGE_START, ITERATIONS, rules)
puts image.sum { |row| row.count { |px| px == '#' } }
