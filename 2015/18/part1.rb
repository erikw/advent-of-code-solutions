#!/usr/bin/env ruby
# frozen_string_literal: true

# GRID_LEN = 6
# STEPS = 4
GRID_LEN = 100
STEPS = 100

def print_grid(grid)
  grid.each do |row|
    puts row.map { |n| n == 1 ? '#' : '.' }.join
  end
end

def next_state(grid, row, col)
  on = (-1..1).sum do |r|
    (-1..1).sum do |c|
      if r == 0 && c == 0 || !(row + r).between?(0, GRID_LEN - 1) || !(col + c).between?(0, GRID_LEN - 1)
        0
      else
        grid[row + r][col + c]
      end
    end
  end
  case grid[row][col]
  when 0 then on == 3 ? 1 : 0
  when 1 then [2, 3].include?(on) ? 1 : 0
  end
end

grid = ARGF.each_line.map do |line|
  line.chomp.split('').map { |c| c == '#' ? 1 : 0 }
end

STEPS.times do
  current = Marshal.load(Marshal.dump(grid))
  print_grid(current)
  (0...GRID_LEN).each do |row|
    (0...GRID_LEN).each do |col|
      grid[row][col] = next_state(current, row, col)
    end
  end
end

puts grid.sum { |row| row.sum }
