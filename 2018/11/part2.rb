#!/usr/bin/env ruby
# frozen_string_literal: true

GRID_DIM = 300

def power_level(serial, x, y)
  rack_id = x + 10
  power = rack_id * y
  power += serial
  power *= rack_id
  power = (power / 100) % 10
  power -= 5
end

# Summed-area table: https://en.wikipedia.org/wiki/Summed-area_table
def power_grid_sat(grid_dim, serial)
  grid = Array.new(grid_dim + 1) { Array.new(grid_dim + 1, 0) }
  (1..grid_dim).each do |y|
    (1..grid_dim).each do |x|
      grid[y][x] = power_level(serial, x, y) +
                   grid[y][x - 1] +
                   grid[y - 1][x] -
                   grid[y - 1][x - 1]
    end
  end
  grid
end

def square_power_sat(grid, dim, x, y)
  grid[y][x] + grid[y - dim][x - dim] - grid[y][x - dim] - grid[y - dim][x]
end

serial = ARGF.readline.to_i
grid = power_grid_sat(GRID_DIM, serial)

largest_power = -Float::INFINITY
largest_cord = nil
largest_sqdim = nil
(1..GRID_DIM).each do |square_dim|
  (square_dim..GRID_DIM).each do |y|
    (square_dim..GRID_DIM).each do |x|
      power = square_power_sat(grid, square_dim, x, y)
      next unless power > largest_power

      largest_power = power
      largest_cord = [x - square_dim + 1, y - square_dim + 1]
      largest_sqdim = square_dim
    end
  end
end

puts largest_cord.concat([largest_sqdim]).join(',')
