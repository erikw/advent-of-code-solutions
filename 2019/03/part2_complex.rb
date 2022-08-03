#!/usr/bin/env ruby
# frozen_string_literal: true
# Re-implementation of part2.rb with Complex numbers.

require 'set'

DIR = { 'U' => -1, 'R' => 1i, 'D' => 1, 'L' => -1i }

def manhattan_dist(p1, p2)
  (p1 - p2).rectangular.map(&:abs).sum
end

wires = ARGF.each_line.map do |line|
  line.chomp.split(',').map { |instr| [instr[0], instr[1..].to_i] }
end

grid = Hash.new { |h, k| h[k] = Set.new } # Complex => Int
intersect_dists = Hash.new(0)
wires.each_with_index do |wire, i|
  pos = 0 + 0i
  steps = 0
  wire.each do |dir, len|
    len.times do
      pos += DIR[dir]
      steps += 1
      unless grid[pos].include?(i)
        grid[pos] << i
        intersect_dists[pos] += steps
      end
    end
  end
end

min_delay = grid.select { |_coord, visitors| visitors.length > 1 }.map do |coord, _visitors|
  intersect_dists[coord]
end.min
puts min_delay
