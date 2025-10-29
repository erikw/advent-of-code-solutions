#!/usr/bin/env ruby
# frozen_string_literal: true

NEIGHBOR_DELTAS = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1]
].freeze

def neighbor_positions(pos)
  NEIGHBOR_DELTAS.map { |dr, dc| [pos[0] + dr, pos[1] + dc] }
end

def discover_region(map, pos)
  area = 0
  perimeter = 0
  region = Set.new
  plant = map[pos]

  stack = [pos]

  until stack.empty?
    pos = stack.pop
    next if region.include?(pos) || map[pos] != plant

    region << pos

    area += 1
    neighbor_positions(pos).each do |posn|
      if map[posn] == plant
        stack << posn
      else
        perimeter += 1
      end
    end
  end

  [area, perimeter, region]
end

map = {}
ARGF.each_line(chomp: true).with_index do |line, row|
  line.each_char.with_index do |plant, col|
    map[[row, col]] = plant
  end
end

total_price = 0
unseen = map.keys.to_set
until unseen.empty?
  area, perimeter, region = discover_region(map, unseen.first)
  unseen -= region
  price = area * perimeter
  total_price += price
end

puts total_price
