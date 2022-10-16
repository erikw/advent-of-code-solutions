#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

tiles = Hash.new(TILE_WHITE) # [cube_coord] -> tile_color
ARGF.each_line do |line|
  coord = track_path(tiles, parse_directions(line.chomp))
  tiles[coord] = !tiles[coord]
end

puts tiles.values.count { |v| v == TILE_BLACK }
