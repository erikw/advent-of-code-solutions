#!/usr/bin/env ruby
# frozen_string_literal: true

# require 'parallel'

SYM_OBSTACLE = '#'
SYM_GUARD = '^'

DIR_UP = -1 + 0i
ROTATE_CLOCKWISE = -1i

def find_path(map, pos, dir, pos_new_obstacle = nil)
  visited = Set.new
  while !visited.include?([pos, dir]) && map.key?(pos)
    visited << [pos, dir]

    pos_n = pos + dir
    if map[pos_n] == SYM_OBSTACLE || pos_n == pos_new_obstacle
      dir *= ROTATE_CLOCKWISE
    else
      pos = pos_n
    end
  end

  [visited, visited.include?([pos, dir])]
end

map = {}
pos_guard = nil
ARGF.each_line(chomp: true).with_index do |line, row|
  line.chars.each_with_index do |sym, col|
    pos = Complex(row, col)
    map[pos] = sym
    pos_guard = pos if sym == SYM_GUARD
  end
end

path = find_path(map, pos_guard, DIR_UP)[0].map(&:first).to_set

new_obstructs = path.count do |pos|
  find_path(map, pos_guard, DIR_UP, pos)[1]
end

# Not faster:
# new_obstructs = Parallel.map(path.to_a, in_threads: 4) do |pos|
# find_path(map, pos_guard, DIR_UP, pos)[1] ? 1 : 0
# end.sum

puts new_obstructs
