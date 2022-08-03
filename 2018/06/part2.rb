#!/usr/bin/env ruby
# frozen_string_literal: true

# MAX_DIST = 32
MAX_DIST = 10_000

def manhattan_distance(p1, p2)
  p1.zip(p2).map { |a, b| (a - b).abs }.sum
end

def dist_to_points(points, point)
  points.map { |p| manhattan_distance(p, point) }.sum
end

points = ARGF.each_line.map { |l| l.split.map(&:to_i) }
x_max = points.map(&:first).max
y_max = points.map(&:last).max

region = (0..y_max).sum do |y|
  (0..x_max).count do |x|
    dist_to_points(points, [x, y]) < MAX_DIST
  end
end
puts region
