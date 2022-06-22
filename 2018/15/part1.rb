#!/usr/bin/env ruby

require_relative 'game'

require 'set'

require 'lazy_priority_queue'

map = read_input
units = create_units(map)
puts play_game(map, units)
