#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_BOX = 'O'
SYM_WALL = '#'
SYM_ROBOT = '@'
SYM_GROUND = '.'
SYM_BBOX_LEFT = '['
SYM_BBOX_RIGHT = ']'

DIR_UP = '^'
DIR_RIGHT = '>'
DIR_DOWN = 'v'
DIR_LEFT = '<'

STEP_DELTA = {
  DIR_UP => Complex(-1, 0),
  DIR_RIGHT => Complex(0, 1),
  DIR_DOWN => Complex(1, 0),
  DIR_LEFT => Complex(0, -1)
}.freeze

EXPANDED_SYM = {
  SYM_WALL => '##',
  SYM_BOX => '[]',
  SYM_GROUND => '..',
  SYM_ROBOT => '@.'
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

def expand_map(map)
  map.map { |row| row.chars.map { |c| EXPANDED_SYM[c] }.join }
end

def move_boxes_horizontal(map, pos_robot, delta)
  pos_runner = pos_robot + delta
  pos_runner += delta * 2 while [SYM_BBOX_LEFT, SYM_BBOX_RIGHT].include?(sym(map, pos_runner))

  return pos_robot unless sym(map, pos_runner) == SYM_GROUND

  pos = pos_runner
  until pos == (pos_robot + delta)
    sym_set(map, pos, sym(map, pos - delta))
    sym_set(map, pos - delta, sym(map, pos - delta * 2))
    pos -= delta * 2
  end
  sym_set(map, pos, sym(map, pos - delta))
  sym_set(map, pos_robot, SYM_GROUND)

  pos_robot + delta
end

def move_vertical?(map, pos, delta)
  case sym(map, pos)
  when SYM_GROUND
    true
  when SYM_WALL
    false
  when SYM_BBOX_LEFT
    move_vertical?(map, pos + delta,
                   delta) && move_vertical?(map, pos + delta + STEP_DELTA[DIR_RIGHT], delta)
  when SYM_BBOX_RIGHT
    move_vertical?(map, pos + delta,
                   delta) && move_vertical?(map, pos + delta + STEP_DELTA[DIR_LEFT], delta)
  end
end

def cascade_move_boxes(map, pos, delta)
  sym = sym(map, pos)
  return unless [SYM_BBOX_LEFT, SYM_BBOX_RIGHT].include?(sym)

  offset = sym == SYM_BBOX_LEFT ? STEP_DELTA[DIR_RIGHT] : STEP_DELTA[DIR_LEFT]
  offset_sym = sym == SYM_BBOX_LEFT ? SYM_BBOX_RIGHT : SYM_BBOX_LEFT

  cascade_move_boxes(map, pos + delta, delta)
  cascade_move_boxes(map, pos + delta + offset, delta)

  sym_set(map, pos, SYM_GROUND)
  sym_set(map, pos + offset, SYM_GROUND)

  sym_set(map, pos + delta, sym)
  sym_set(map, pos + delta + offset, offset_sym)
end

def move_boxes_vertical(map, pos_robot, delta)
  return pos_robot unless move_vertical?(map, pos_robot + delta, delta)

  cascade_move_boxes(map, pos_robot + delta, delta)
  sym_set(map, pos_robot, SYM_GROUND)
  sym_set(map, pos_robot + delta, SYM_ROBOT)

  pos_robot + delta
end

in_map, in_directions = ARGF.read.split("\n\n")

map = expand_map(in_map.lines.map(&:chomp))

pos_robot = catch(:found) do
  map.each_with_index do |line, row|
    line.each_char.with_index do |sym, col|
      throw :found, Complex(row, col) if sym == SYM_ROBOT
    end
  end
end

directions = in_directions.gsub(/\n/, '')

directions.each_char do |direction|
  delta = STEP_DELTA[direction]
  pos_runner = pos_robot + delta
  sym = sym(map, pos_runner)

  if sym == SYM_WALL
    # nop
  elsif sym == SYM_GROUND
    sym_set(map, pos_robot, SYM_GROUND)
    pos_robot = pos_runner
    sym_set(map, pos_robot, SYM_ROBOT)
  elsif [DIR_RIGHT, DIR_LEFT].include?(direction)
    pos_robot = move_boxes_horizontal(map, pos_robot, delta)
  else
    pos_robot = move_boxes_vertical(map, pos_robot, delta)
  end
end

gps_sum = (0...map.size).to_a.product((0...map.first.size).to_a).select do |p|
  sym(map, Complex(*p)) == SYM_BBOX_LEFT
end.sum do |y, x|
  y * 100 + x
end

puts gps_sum
