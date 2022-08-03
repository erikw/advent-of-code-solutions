#!/usr/bin/env ruby
# frozen_string_literal: true

KEYPAD = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
code = []
row = 1
col = 1
ARGF.each_line.map(&:chars).each do |instructions|
  instructions.each do |instr|
    case instr
    when 'U' then row = [0, row - 1].max
    when 'R' then col = [KEYPAD[0].length - 1, col + 1].min
    when 'D' then row = [KEYPAD.length - 1, row + 1].min
    when 'L' then col = [0, col - 1].max
    end
  end
  code << KEYPAD[row][col]
end
puts code.join
