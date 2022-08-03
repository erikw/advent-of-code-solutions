#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

map = read_input
units = create_units(map)
puts play_game(map, units)
