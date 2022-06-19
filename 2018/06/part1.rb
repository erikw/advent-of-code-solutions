#!/usr/bin/env ruby

def manhattan_distance(p1, p2)
  p1.zip(p2).map { |a, b| (a - b).abs }.sum
end

def closest_point(points, x, y)
  distances = points.map do |p|
    [manhattan_distance(p, [x, y]), p]
  end
  min_dist_point = distances.min_by(&:first)
  points = distances.select { |d, _p| d == min_dist_point[0] }

  if points.length > 1
    # '.'
    nil
  else
    min_dist_point[1]
  end
end

def is_infinite(grid, x_max, y_max, px, py)
  [grid[0][px], grid[y_max][px], grid[py][0], grid[py][x_max]].include?([px, py])
end

def area(grid, _x_max, _y_max, point)
  grid.flatten(1).count do |p|
    p == point
  end
end

points = ARGF.each_line.map { |l| l.split.map(&:to_i) }
x_max = points.map(&:first).max
y_max = points.map(&:last).max

grid = Array.new(y_max + 1)
(0...grid.length).each do |y|
  grid[y] = Array.new(x_max + 1)
  (0...grid[0].length).each do |x|
    grid[y][x] = closest_point(points, x, y)
  end
end

finite_points = points.reject { |x, y| is_infinite(grid, x_max, y_max, x, y) }
puts finite_points.map { |p| area(grid, x_max, y_max, p) }.max
