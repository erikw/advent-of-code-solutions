#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer_iter'

AREA_DIM = 50

DRONE_STATIONARY = 0
DRONE_PULLED = 1

SYM_STATIONARY = '.'
SYM_PULLED = '#'

def scan(intcode, x, y)
  computer = Computer.new(intcode)
  computer.stdin << x << y
  computer.execute
  computer.stdout.pop
end

def print_area(area)
  area.each do |row|
    puts row.map { |c| c == DRONE_STATIONARY ? SYM_STATIONARY : SYM_PULLED }.join
  end
end

intcode = ARGF.readline.split(',').map(&:to_i)

area = Array.new(AREA_DIM) { Array.new(AREA_DIM) }
(0...AREA_DIM).each do |y|
  (0...AREA_DIM).each do |x|
    area[y][x] = scan(intcode, x, y)
  end
end
# print_area(area)

total_pulled = area.sum do |row|
  row.count { |c| c == DRONE_PULLED }
end
puts total_pulled
