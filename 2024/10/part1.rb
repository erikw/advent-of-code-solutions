#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_SKIP = '.'

LEVEL_LO = 0
LEVEL_HI = 9

NEIGHBOR_DELTAS = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1]
].freeze

def neighbours(map, (row, col))
  NEIGHBOR_DELTAS.map { |dr, dc| [row + dr, col + dc] }.select { |p| map.key?(p) }
end

def trail_ends(map, pos, cache)
  return cache[pos] if cache.key?(pos)

  cache[pos] = if !map.key?(pos)
                 [nil]
               elsif map[pos] == LEVEL_HI
                 [pos]
               else
                 neighbours(map, pos).flat_map do |posn|
                   next nil unless map[posn] == map[pos] + 1

                   trail_ends(map, posn, cache)
                 end.uniq.compact
               end
end

def trailhead_score(map, pos, cache)
  trail_ends(map, pos, cache).size
end

trailheads = []
map = {}
ARGF.each_line(chomp: true).with_index do |line, row|
  line.each_char.with_index do |sym, col|
    pos = [row, col]
    map[pos] = sym.to_i unless sym == SYM_SKIP
    trailheads << pos if sym == LEVEL_LO.to_s
  end
end

cache = {}
scores = trailheads.sum do |trailhead|
  trailhead_score(map, trailhead, cache)
end

puts scores
