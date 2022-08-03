#!/usr/bin/env ruby
# frozen_string_literal: true

GRID_DIM = 300
SQUARE_DIM = 3

def power_level(serial, x, y)
  rack_id = x + 10
  power = rack_id * y
  power += serial
  power *= rack_id
  power = (power / 100) % 10
  power -= 5
end

def power_grid(grid_dim, serial)
  grid = Array.new(grid_dim + 1) { Array.new(grid_dim + 1) }
  (1..grid_dim).each do |y|
    (1..grid_dim).each do |x|
      grid[y][x] = power_level(serial, x, y)
    end
  end
  grid
end

def square_power(grid, dim, x, y)
  power = 0
  (0...dim).each do |dy|
    (0...dim).each do |dx|
      power += grid[y + dy][x + dx]
    end
  end
  power
end

def largest_square(grid_dim, square_dim, grid)
  largest_power = -Float::INFINITY
  largest_cord = nil
  (1...(grid_dim - square_dim)).each do |y|
    (1...(grid_dim - square_dim)).each do |x|
      power = square_power(grid, square_dim, x, y)
      if power > largest_power
        largest_power = power
        largest_cord = [x, y]
      end
    end
  end
  [largest_cord, largest_power]
end

serial = ARGF.readline.to_i
grid = power_grid(GRID_DIM, serial)
cord, _power = largest_square(GRID_DIM, SQUARE_DIM, grid)
puts cord.join(',')
