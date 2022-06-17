#!/usr/bin/env ruby

# SIDE = 11
SIDE = 1000
CLAIM_PATTERN = /#\d+ @ (\d+),(\d+): (\d+)x(\d+)/

fabric = Array.new(SIDE) { Array.new(SIDE, 0) }

ARGF.each_line do |line|
  left, top, wide, tall = line.match(CLAIM_PATTERN)[1..].map(&:to_i)
  (top...(top + tall)).each do |row|
    (left...(left + wide)).each do |col|
      fabric[row][col] += 1
    end
  end
end

puts fabric.sum { |row| row.count { |p| p > 1 } }
