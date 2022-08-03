#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../09/computer'

COLOR_BLACK = 0
COLOR_WHITE = 1
DIRECTION = { 0 => 1i, 1 => -1i }
COLOR = {
  COLOR_BLACK => '.',
  COLOR_WHITE => '#'
}

intcode = ARGF.readline.split(',').map(&:to_i)

panels = Hash.new(COLOR_BLACK) # Coordinate => color
dir = -1 # [-1, i, 1, -i] == [north, east, south, west]
pos = 0 + 0i
panels[pos] = COLOR_WHITE

computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

while comp_thr.alive?
  computer.stdin << panels[pos]
  panels[pos] = computer.stdout.pop
  pos += dir *= DIRECTION[computer.stdout.pop]
end

xmin, xmax = panels.keys.map(&:real).minmax
ymin, ymax = panels.keys.map(&:imag).minmax
(xmin..xmax).each do |x|
  (ymin..ymax).each do |y|
    print COLOR[panels[Complex(x, y)]]
  end
  puts
end
