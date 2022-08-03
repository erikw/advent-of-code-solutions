#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def manhattan_dist(p1, p2)
  p1.zip(p2).map { |x1, x2| (x1 - x2).abs }.sum
end

wires = ARGF.each_line.map do |line|
  line.chomp.split(',').map { |instr| [instr[0], instr[1..].to_i] }
end

grid = Hash.new { |h, k| h[k] = Set.new } # [x, y] => Int
intersect_dists = Hash.new(0)
wires.each_with_index do |wire, i|
  x = 0
  y = 0
  steps = 0
  wire.each do |dir, len|
    len.times do
      case dir
      when 'U' then x -= 1
      when 'R' then y += 1
      when 'D' then x += 1
      when 'L' then y -= 1
      end
      steps += 1
      unless grid[[x, y]].include?(i)
        grid[[x, y]] << i
        intersect_dists[[x, y]] += steps
      end
    end
  end
end

min_delay = grid.select { |_coord, visitors| visitors.length > 1 }.map do |coord, _visitors|
  intersect_dists[coord]
end.min
puts min_delay
