#!/usr/bin/env ruby
# frozen_string_literal: true

BOUND = 50

space = Array.new(2*BOUND + 1)
(0...space.length).each do |x|
  space[x] = Array.new(2*BOUND + 1)
  (0...space[x].length).each do |y|
    space[x][y] = Array.new(2*BOUND + 1)
  end
end

ARGF.each_line do |line|
  mode, rest = line.split
  mode = (mode == "on") ? 1 : 0
  range_x, range_y, range_z = rest.split(',').map do |rangestr|
    rangestr[2..].split('..').map(&:to_i)
  end
  if range_x[0].between?(-BOUND, BOUND) && range_x[1].between?(-BOUND, BOUND) &&
      range_y[0].between?(-BOUND, BOUND) && range_y[1].between?(-BOUND, BOUND) &&
      range_z[0].between?(-BOUND, BOUND) && range_z[1].between?(-BOUND, BOUND)
    (range_x[0]..range_x[1]).each do |x|
      (range_y[0]..range_y[1]).each do |y|
        (range_z[0]..range_z[1]).each do |z|
          space[x + BOUND][y + BOUND][z + BOUND ] = mode
        end
      end
    end
  end
end

puts space.flatten.count(1)
