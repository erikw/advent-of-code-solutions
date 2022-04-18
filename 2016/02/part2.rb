#!/usr/bin/env ruby

KEYPAD = [
  %w[x x x x x x x],
  %w[x x x 1 x x x],
  %w[x x 2 3 4 x x],
  %w[x 5 6 7 8 9 x],
  %w[x x A B C x x],
  %w[x x x D x x x],
  %w[x x x x x x x]
]

code = []
row = 3
col = 1
ARGF.each_line.map(&:chars).each do |instructions|
  instructions.each do |instr|
    rinc = 0
    cinc = 0
    case instr
    when 'U' then rinc = -1
    when 'R' then cinc =  1
    when 'D' then rinc =  1
    when 'L' then cinc = -1
    end
    unless KEYPAD[row + rinc][col + cinc] == 'x'
      row += rinc
      col += cinc
    end
  end
  code << KEYPAD[row][col]
end
puts code.join
