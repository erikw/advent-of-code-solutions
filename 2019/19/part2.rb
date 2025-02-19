#!/usr/bin/env ruby
# frozen_string_literal: true

# h/t https://www.reddit.com/r/adventofcode/comments/ecogl3/comment/fbdmn5n/?utm_source=share&utm_medium=web2x&context=3
# Algorithm:
# * Fit the SHIP_DIM * SHIP_DIM square by moving it diagonally down.
# x
# x
#  x
#   x
#   x
#   x
#    x
#     x
#     x

require '../09/computer_iter'

SHIP_DIM = 100

DRONE_STATIONARY = 0
DRONE_PULLED = 1

def scan(intcode, x, y)
  computer = Computer.new(intcode)
  computer.stdin << x << y
  computer.execute
  computer.stdout.pop
end

def is_pulled?(intcode, x, y)
  scan(intcode, x, y) == DRONE_PULLED
end

intcode = ARGF.readline.split(',').map(&:to_i)
x = 0
y = 0

until is_pulled?(intcode, x + SHIP_DIM - 1, y)
  y += 1
  x += 1 until is_pulled?(intcode, x, y + SHIP_DIM - 1)
end

puts x * 10_000 + y
