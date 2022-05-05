#!/usr/bin/env ruby

require 'digest'

GRID_DIM = 4
DIRECTIONS = [ [-1,  0], [1,  0], [0, -1], [0,  1] ]
INDEX2DIR = {0 => 'U', 1 => 'D', 2 => 'L', 3 => 'R' }

passcode = ARGF.readline.chomp

def door_open(row, col, hashcode)
  row.between?(0, GRID_DIM-1) && col.between?(0, GRID_DIM-1) && hashcode.match?(/[b-f]/)
end

def longest_path(passcode, path=[], row=0, col=0)
  return path if row == GRID_DIM-1 && col == GRID_DIM-1

  hash = Digest::MD5.hexdigest(passcode + path.join)[...4]
  paths = []

  DIRECTIONS.each_with_index do |d, i|
    if door_open(row+d[0], col+d[1], hash[i])
      paths << longest_path(passcode, path.dup.append(INDEX2DIR[i]), row+d[0], col+d[1])
    end
  end

  paths.reject(&:nil?).max_by(&:length)
end

puts longest_path(passcode).length
