#!/usr/bin/env ruby

# ITERATIONS = 7
# ITERATIONS = 70
ITERATIONS = 10_000

NODE_CLEAN = '.'
NODE_INFECTED = '#'

DIRECTION_DELTA = { NODE_CLEAN => -1,
                    NODE_WEAKENED => 0,
                    NODE_INFECTED => 1,
                    NODE_FLAGGED => 2 }
STATE_TRANSITIONS = { NODE_CLEAN => NODE_WEAKENED,
                      NODE_WEAKENED => NODE_INFECTED,
                      NODE_INFECTED => NODE_FLAGGED,
                      NODE_FLAGGED => NODE_CLEAN }
CORD_DELTA = { 0 => [-1, 0],
               1 => [0, 1],
               2 => [1, 0],
               3 => [0, -1] }

grid = Hash.new(NODE_CLEAN)
rows = 0
cols = 0
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |node, col|
    grid[[row, col]] = node
    cols = [cols, col].max
  end
  rows = [rows, row].max
end

direction = 0 # 0=up, 1=right, 2=down, 3=left
cords = [rows / 2, cols / 2]
infections = 0
ITERATIONS.times do
  direction = (direction + DIRECTION_DELTA[grid[cords]]) % 4
  grid[cords] = STATE_TRANSITIONS[grid[cords]]
  infections += 1 if grid[cords] == NODE_INFECTED
  cords = cords.zip(CORD_DELTA[direction]).map(&:sum)
end

puts infections
