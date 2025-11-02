#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_BOX = 'O'
SYM_WALL = '#'
SYM_ROBOT = '@'
SYM_GROUND = '.'

STEP_DELTA = {
  '^' => Complex(-1, 0),
  '>' => Complex(0, 1),
  'v' => Complex(1, 0),
  '<' => Complex(0, -1)
}.freeze

def print_map(map)
  puts map.join("\n")
  puts
end

def sym(map, pos)
  map[pos.real][pos.imag]
end

def sym_set(map, pos, sym)
  map[pos.real][pos.imag] = sym
end

in_map, in_directions = ARGF.read.split("\n\n")

map = in_map.lines.map(&:chomp)
pos_robot = catch(:found) do
  map.each_with_index do |line, row|
    line.each_char.with_index do |sym, col|
      throw :found, Complex(row, col) if sym == SYM_ROBOT
    end
  end
end

directions = in_directions.gsub(/\n/, '')

directions.each_char do |direction|
  pos_runner = pos_robot + STEP_DELTA[direction]
  case sym(map, pos_runner)
  when SYM_WALL
    next
  when SYM_GROUND
    sym_set(map, pos_robot, SYM_GROUND)
    pos_robot = pos_runner
    sym_set(map, pos_robot, SYM_ROBOT)
  when SYM_BOX
    loop do
      pos_runner += STEP_DELTA[direction]
      break unless sym(map, pos_runner) == SYM_BOX
    end

    if sym(map, pos_runner) == SYM_GROUND
      sym_set(map, pos_robot, SYM_GROUND)
      pos_robot += STEP_DELTA[direction]
      sym_set(map, pos_robot, SYM_ROBOT)
      sym_set(map, pos_runner, SYM_BOX)
    end
  end
end

gps_sum = (0...map.size).to_a.product((0...map.first.size).to_a).select do |p|
  sym(map, Complex(*p)) == SYM_BOX
end.sum do |y, x|
  y * 100 + x
end

puts gps_sum
