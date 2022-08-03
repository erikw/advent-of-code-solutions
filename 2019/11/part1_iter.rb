#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../09/computer_iter'

COLOR_BLACK = 0
COLOR_WHITE = 1
PANEL_BLACK = '.'
PANEL_WHITE = '#'
DIRECTION = { 0 => 1i, 1 => -1i }

intcode = ARGF.readline.split(',').map(&:to_i)

panels = Hash.new(COLOR_BLACK) # Coordinate => color
dir = -1 # [-1, i, 1, -i] == [north, east, south, west]
pos = 0 + 0i

computer = Computer.new(intcode)
status = nil
until status == Computer::STATUS_DONE
  status = computer.execute
  case status
  when Computer::STATUS_INPUT_NEEDED
    computer.stdin << panels[pos]
  when Computer::STATUS_OUTPUT
    if computer.stdout.length >= 2
      panels[pos] = computer.stdout.pop
      pos += dir *= DIRECTION[computer.stdout.pop]
    end
  end
end

puts panels.size
