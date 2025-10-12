#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_OBSTACLE = '#'
SYM_GUARD = '^'

DIR_UP = -1 + 0i
ROTATE_CLOCKWISE = -1i

map = {}
pos_guard = nil
ARGF.each_line(chomp: true).with_index do |line, row|
  line.chars.each_with_index do |sym, col|
    pos = Complex(row, col)
    map[pos] = sym
    pos_guard = pos if sym == SYM_GUARD
  end
end

pos = pos_guard
dir = DIR_UP
visited = Set[pos]
loop do
  pos_n = pos + dir
  break unless map.key?(pos_n)

  if map[pos_n] == SYM_OBSTACLE
    dir *= ROTATE_CLOCKWISE
  else
    pos = pos_n
    visited << pos
  end
end

puts visited.size
