#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

ITERATIONS = 18

rules = parse_rules(ARGF)
image = enhance_image(IMAGE_START, ITERATIONS, rules)
puts image.sum { |row| row.count { |px| px == '#' } }
