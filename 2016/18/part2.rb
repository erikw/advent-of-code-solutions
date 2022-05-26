#!/usr/bin/env ruby

ROWS = 400_000
TILE_SAFE = '.'
TILE_TRAP = '^'

start_row = [TILE_SAFE] + ARGF.readline.chomp.split('') + [TILE_SAFE]
tiles = [start_row, start_row.dup]
safe_count = tiles[0][1..-2].count { |tile| tile == TILE_SAFE }

(ROWS - 1).times do |i|
  prev = i % 2
  cur = prev ^ 1
  (1...tiles[0].length - 1).each do |col|
    if tiles[prev][col - 1] == tiles[prev][col + 1]
      tiles[cur][col] = TILE_SAFE
      safe_count += 1
    else
      tiles[cur][col] = TILE_TRAP
    end
  end
end

puts safe_count
