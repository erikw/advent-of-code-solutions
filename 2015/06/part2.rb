#!/usr/bin/env ruby
# frozen_string_literal: true

grid = Array.new(1000) { Array.new(1000, 0) }
ARGF.each_line.map { |l| l.delete_prefix('turn').split }.each do |cmd, pt1, _, pt2|
  x1, y1 = pt1.split(',').map(&:to_i)
  x2, y2 = pt2.split(',').map(&:to_i)
  if x2 < x1 || y2 < y1
    x1, x2 = x2, x1
    y1, y2 = y2, y1
  end

  (x1..x2).each do |x|
    (y1..y2).each do |y|
      case cmd
      when 'on' then grid[x][y] += 1
      when 'off' then grid[x][y] = [0, grid[x][y] - 1].max
      when 'toggle' then grid[x][y] += 2
      end
    end
  end
end

puts grid.sum { |r| r.sum }
