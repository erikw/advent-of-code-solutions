#!/usr/bin/env ruby

require 'set'

START_X = 1
START_Y = 1

# TARGET_X = 7
# TARGET_Y = 4
TARGET_X = 31
TARGET_Y = 39
DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def is_wall(fave_num, x, y)
  n = x**2 + 3 * x + 2 * x * y + y + y**2 + fave_num
  n.to_s(2).count('1').odd?
end

def shortest_path_to(target_x, target_y, fave_num, x, y, visited = Set.new)
  if x < 0 || y < 0 || is_wall(fave_num, x, y) || visited.include?([x, y])
    Float::INFINITY
  elsif x == target_x && y == target_y
    0
  else
    visited << [x, y]
    dist = 1 + DIRECTIONS.map do |dx, dy|
      shortest_path_to(target_x, target_y, fave_num, x + dx, y + dy, visited)
    end.min
    visited.delete([x, y])
    dist
  end
end

fave_num = ARGF.readline.to_i
puts shortest_path_to(TARGET_X, TARGET_Y, fave_num, START_X, START_Y)
