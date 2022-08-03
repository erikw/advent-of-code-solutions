#!/usr/bin/env ruby
# frozen_string_literal: true

def manhattan_distance(pos1, pos2)
  pos1.zip(pos2).map { |a, b| (a - b).abs }.sum
end

nanobots = ARGF.each_line.map do |line|
  x, y, z, r = line.scan(/-?\d+/).map(&:to_i)
  [[x, y, z], r]
end

strongest = nanobots.max_by(&:last)
in_range = nanobots.count do |nanobot|
  manhattan_distance(strongest[0], nanobot[0]) <= strongest.last
end
puts in_range
