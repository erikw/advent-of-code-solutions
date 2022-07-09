#!/usr/bin/env ruby
# Re-implementation of part1.rb with Complex numbers.

require 'set'

DIR = { 'U' => -1, 'R' => 1i, 'D' => 1, 'L' => -1i }

def manhattan_dist(p1, p2)
  (p1 - p2).rectangular.map(&:abs).sum
end

wires = ARGF.each_line.map do |line|
  line.chomp.split(',').map { |instr| [instr[0], instr[1..].to_i] }
end

grid = Hash.new { |h, k| h[k] = Set.new } # Complex => Int
wires.each_with_index do |wire, i|
  pos = 0 + 0i
  wire.each do |dir, len|
    len.times do
      pos += DIR[dir]
      grid[pos] << i
    end
  end
end

puts grid.select { |_c, visitors| visitors.length > 1 }.map { |c, _| manhattan_dist(0, c) }.min
