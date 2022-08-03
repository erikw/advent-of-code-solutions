#!/usr/bin/env ruby
# frozen_string_literal: true

# ROWS = 3
# ROWS = 10
ROWS = 40
TILE_SAFE = '.'
TILE_TRAP = '^'

tiles = [[TILE_SAFE] + ARGF.readline.chomp.split('') + [TILE_SAFE]]
cols = tiles[0].length

(1...ROWS).each do |row|
  tiles << Array.new(cols)
  (0...cols).each do |col|
    tiles[row][col] = if [0, cols - 1].include?(col) || tiles[row - 1][col - 1] == tiles[row - 1][col + 1]
                        TILE_SAFE
                      else
                        TILE_TRAP
                      end
  end
end

tiles.each do |row|
  puts row[1..-2].join
end

cnt = tiles.sum do |row|
  row[1..-2].count do |tile|
    tile == TILE_SAFE
  end
end

puts cnt
