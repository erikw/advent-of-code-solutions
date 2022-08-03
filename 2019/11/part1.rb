#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../09/computer'

COLOR_BLACK = 0
COLOR_WHITE = 1
PANEL_BLACK = '.'
PANEL_WHITE = '#'
DIRECTION = { 0 => 1i, 1 => -1i }

intcode = ARGF.readline.split(',').map(&:to_i)

panels = Hash.new(COLOR_BLACK) # Coordinate => color
dir = -1 # [-1, i, 1, -i] == [north, east, south, west]
pos = 0 + 0i

computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

while comp_thr.alive?
  computer.stdin << panels[pos]
  panels[pos] = computer.stdout.pop
  pos += dir *= DIRECTION[computer.stdout.pop]
end

puts panels.size
