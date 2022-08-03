#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../09/computer'

TILE_EMPTY = 0
TILE_WALL = 1
TILE_BLOCK = 2
TILE_HPADDLE = 3
TILE_BALL = 4

intcode = ARGF.readline.split(',').map(&:to_i)

tiles = Hash.new(TILE_EMPTY) # Coordinate => tile
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }

while comp_thr.alive? || !computer.stdout.empty?
  x = computer.stdout.pop
  y = computer.stdout.pop
  tile = computer.stdout.pop
  tiles[Complex(x, y)] = tile
end

puts tiles.values.count { |t| t == TILE_BLOCK }
