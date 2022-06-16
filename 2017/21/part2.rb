#!/usr/bin/env ruby

require_relative 'lib'

ITERATIONS = 18

rules = parse_rules(ARGF)
image = enhance_image(IMAGE_START, ITERATIONS, rules)
puts image.sum { |row| row.count { |px| px == '#' } }
