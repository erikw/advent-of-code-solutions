#!/usr/bin/env ruby
# frozen_string_literal: true

WIDTH = 50
HEIGHT = 6

OFF = ' '
ON = '0'

def print_disp(disp)
  disp.each do |row|
    puts row.join
  end
end

display = Array.new(HEIGHT) { Array.new(WIDTH, OFF) }

ARGF.each_line.map(&:split).each do |args|
  case args
  in ["rect", dim]
    a, b = dim.split('x').map(&:to_i)
    (0...b).each do |row|
      (0...a).each do |col|
        display[row][col] = ON
      end
    end
  in ["rotate", "row", row, "by", rot]
    row = row[2..].to_i
    rot = rot.to_i
    display[row].rotate!(-rot)
  in ["rotate", "column", col, "by", rot]
    col = col[2..].to_i
    rot = rot.to_i
    display = display.transpose
    display[col].rotate!(-rot)
    display = display.transpose
  end
end

print_disp(display)
