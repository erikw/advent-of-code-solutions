#!/usr/bin/env ruby

require_relative 'lib'

points = ARGF.each_line.map do |line|
  x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  [[x, y], [vx, vy]]
end

print_message(search_message(points)[0])
