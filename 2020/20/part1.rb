#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

tiles, edges = read_input
corners = find_corner_tiles(tiles, edges)
puts corners.inject(&:*)
