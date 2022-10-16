#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

DAYS = 100

# [r, s, q]
NEIGHBOUR_DELTAS = [
  [0, -1, 1],
  [1, -1, 0],
  [1, 0, -1],
  [0, 1, -1],
  [-1, 1, 0],
  [-1, 0, 1]
]

def neighbour_coords(coord)
  NEIGHBOUR_DELTAS.map do |delta|
    coord.zip(delta).map { |c, d| c + d }
  end
end

def color(tiles, tiles_next, coord)
  nbr_black = neighbour_coords(coord).count { |n| tiles[n] == TILE_BLACK }

  if tiles[coord] == TILE_BLACK && (nbr_black == 0 || nbr_black > 2)
    tiles_next[coord] = TILE_WHITE
  elsif tiles[coord] == TILE_WHITE && nbr_black == 2
    tiles_next[coord] = TILE_BLACK
  end
end

tiles = Hash.new(TILE_WHITE) # [cube_coord] -> tile_color
ARGF.each_line do |line|
  coord = track_path(tiles, parse_directions(line.chomp))
  tiles[coord] = !tiles[coord]
end

DAYS.times do |_day|
  tiles_next = tiles.dup

  tiles.each_key do |coord|
    color(tiles, tiles_next, coord)
    neighbour_coords(coord).each do |ncoord|
      color(tiles, tiles_next, ncoord)
    end
  end

  tiles = tiles_next

  # nbr_black = tiles.values.count { |v| v == TILE_BLACK }
  # puts "Day #{day + 1}: #{nbr_black}"
end

puts tiles.values.count { |v| v == TILE_BLACK }
