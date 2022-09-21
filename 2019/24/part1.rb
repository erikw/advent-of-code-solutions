#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

SYM_BUG = '#'
SYM_EMPTY = '.'

DIM = 5
CORD_DELTA_NEIGHBOURS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

def update_neighbours(tiles, neighbours)
  tiles.length.times do |row|
    tiles[0].length.times do |col|
      neighbours[row][col] = 0
      CORD_DELTA_NEIGHBOURS.each do |dr, dc|
        rown = row + dr
        coln = col + dc
        next unless rown.between?(0, tiles.length - 1) && coln.between?(0, tiles[0].length - 1)

        neighbours[row][col] += 1 if tiles[rown][coln] == SYM_BUG
      end
    end
  end
end

def tick(tiles, neighbours)
  tiles.length.times do |row|
    tiles[0].length.times do |col|
      if tiles[row][col] == SYM_BUG && neighbours[row][col] != 1
        tiles[row][col] = SYM_EMPTY
      elsif tiles[row][col] == SYM_EMPTY && [1, 2].include?(neighbours[row][col])
        tiles[row][col] = SYM_BUG
      end
    end
  end
end

def biodiversity(tiles)
  tiles.flatten.each_with_index.sum do |t, i|
    t == SYM_BUG ? 2**i : 0
  end
end

def print_tiles(tiles)
  tiles.each do |row|
    puts row.join
  end
end

tiles = ARGF.each_line.map { |line| line.chomp.chars }
neighbours = Array.new(DIM) { Array.new(DIM) }
seen = Set.new

loop do
  update_neighbours(tiles, neighbours)
  tick(tiles, neighbours)
  biodiv = biodiversity(tiles)
  if seen.include?(biodiv)
    puts biodiv
    exit
  end
  seen << biodiv
end
