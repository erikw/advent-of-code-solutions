#!/usr/bin/env ruby
# frozen_string_literal: true

# Algorithm:
# * Binary search. Howvery it won't work in all inputs, because the beam is not
#   monotonically increasing, it's jumping a bit because of the resolution.

require '../09/computer_iter'

SHIP_DIM = 100

DRONE_STATIONARY = 0
DRONE_PULLED = 1

SYM_STATIONARY = '.'
SYM_PULLED = '#'

def scan(intcode, x, y)
  computer = Computer.new(intcode)
  computer.stdin << x << y
  computer.execute
  computer.stdout.pop
end

def beam_right_x(intcode, y)
  x = 0
  x += 1 until scan(intcode, x, y) == DRONE_PULLED
  x += 1 until scan(intcode, x, y) == DRONE_STATIONARY
  x - 1
end

def ship_fits?(intcode, y)
  x = beam_right_x(intcode, y)

  scan(intcode, x - SHIP_DIM, y) == DRONE_PULLED &&
    scan(intcode, x, y + SHIP_DIM) == DRONE_PULLED &&
    scan(intcode, x - SHIP_DIM, y + SHIP_DIM) == DRONE_PULLED
end

def bin_search(intcode, y_lo, y_hi)
  last_fit = Float::INFINITY
  while y_lo <= y_hi
    y_mid = (y_hi - y_lo) / 2 + y_lo
    puts "bin_searching y_lo=#{y_lo}, y_hi=#{y_hi}, y_mid=#{y_mid}, last_fit=#{last_fit}"

    if ship_fits?(intcode, y_mid)
      y_hi = y_mid - 1
      last_fit = [last_fit, y_mid].min
    else
      y_lo = y_mid + 1
    end
  end
  last_fit
end

intcode = ARGF.readline.split(',').map(&:to_i)

y_hi = 300
y_hi *= 2 until ship_fits?(intcode, y_hi)

y_closest = bin_search(intcode, 0, y_hi)
x_closest = beam_right_x(intcode, y_closest) - SHIP_DIM
puts "x_closest: #{x_closest}, y_closest: #{y_closest}"
puts x_closest * 10_000 + y_closest
