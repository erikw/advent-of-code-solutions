#!/usr/bin/env ruby

require 'set'

START_X = 1
START_Y = 1
TARGET_X = 31
TARGET_Y = 39
MAX_DEPTH = 50
DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def is_wall(fave_num, x, y)
  n = x**2 + 3 * x + 2 * x * y + y + y**2 + fave_num
  n.to_s(2).count('1').odd?
end

def num_locations(x, y, depth, fave_num, locations, visited = Set.new)
  return if x < 0 || y < 0 || depth < 0 || is_wall(fave_num, x, y) || visited.include?([x, y])

  locations << [x, y]
  visited << [x, y]
  DIRECTIONS.each do |dx, dy|
    num_locations(x + dx, y + dy, depth - 1, fave_num, locations, visited)
  end
  visited.delete([x, y])
end

fave_num = ARGF.readline.to_i
locations = Set.new
num_locations(START_X, START_Y, MAX_DEPTH, fave_num, locations)
puts locations.size
