#!/usr/bin/env ruby
# frozen_string_literal: true

NEIGHBOR_DELTAS = [-1, 1i, 1, -1i].freeze

CORNER_DELTAS = [
  [-1i, -1 - 1i, -1], # top left
  [-1, -1 + 1i, 1i], # top right
  [1i, 1 + 1i, 1], # bottom right
  [1, 1 - 1i, -1i] # bottom left
].freeze

def neighbor_positions(pos)
  NEIGHBOR_DELTAS.map { |d| pos + d }
end

def corner_neighbours(pos)
  CORNER_DELTAS.map { |deltas| deltas.map { |d| pos + d } }
end

def sorted_positions(*positions)
  positions.sort_by { |p| [p.real, p.imag] }
end

def outer_corner(region, pos, pos1, _pos2, pos3)
  is_corner = [pos1, pos3].none? do |p|
    region.include?(p)
  end

  pos_corner = sorted_positions(pos, pos1, pos3)

  is_corner ? pos_corner : nil
end

def inner_corner(region, pos, pos1, pos2, pos3)
  is_corner = region.include?(pos2) && region.include?(pos1) ^ region.include?(pos3)

  pos_side = region.include?(pos1) ? pos1 : pos3
  pos_corner = sorted_positions(pos, pos2, pos_side)

  is_corner ? pos_corner : nil
end

def discover_region(map, pos)
  region = Set.new
  plant = map[pos]

  stack = [pos]

  until stack.empty?
    pos = stack.pop
    next if region.include?(pos) || map[pos] != plant

    region << pos

    neighbor_positions(pos).each do |posn|
      stack << posn if map[posn] == plant
    end
  end

  region
end

def count_sides(region)
  corners = Set.new

  region.each do |pos|
    corner_neighbours(pos).each do |pos1, pos2, pos3|
      pos_corner = outer_corner(region, pos, pos1, pos2, pos3) || inner_corner(region, pos, pos1, pos2, pos3)
      corners << pos_corner if pos_corner
    end
  end

  corners.size
end

map = {}
ARGF.each_line(chomp: true).with_index do |line, row|
  line.each_char.with_index do |plant, col|
    map[Complex(row, col)] = plant
  end
end

unseen = map.keys.to_set
regions = []
until unseen.empty?
  region = discover_region(map, unseen.first)
  unseen -= region
  regions << region
end

total_price = regions.sum do |region|
  area = region.size
  sides = count_sides(region)
  area * sides
end

puts total_price
