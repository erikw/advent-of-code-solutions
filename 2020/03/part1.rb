#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

SLOPE = 1 + 3i

map = read_input
puts trees_hit(map, SLOPE)
