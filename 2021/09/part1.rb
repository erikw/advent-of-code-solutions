#!/usr/bin/env ruby
# frozen_string_literal: true

def smaller_than(values, row1, col1, row2, col2)
  # puts "Testing values[#{row1}][#{col1}]=#{values[row1][col1]} against values[#{row2}][#{col2}]=#{values[row2][col2]}"
  if row2.between?(0, values.length - 1) && col2.between?(0, values[0].length - 1)
    values[row1][col1] < values[row2][col2]
  else
    true
  end
end

heightmap = ARGF.each_line.map { |line| line.chomp.split('').map(&:to_i) }

lowpoints = []
(0...heightmap.length).each do |row|
  (0...heightmap[0].length).each do |col|
    next unless [[row, col - 1], [row - 1, col], [row, col + 1], [row + 1, col]].all? do |r, c|
                  smaller_than(heightmap, row, col, r, c)
                end

    lowpoints << heightmap[row][col]
  end
end
risk = lowpoints.map { |p| p + 1 }.sum
puts risk
