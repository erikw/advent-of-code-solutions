#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

row = 0
col = 0
facing = 0
visited = Set.new([row, col])
ARGF.readline.split(', ').map {|p| [p[0], p[1..].to_i] }.each do |turn, dist|
  facing = (facing + (turn == 'R' ? 1 : -1)) % 4
  row_inc, col_inc = 0, 0
  case facing
  when 0 then row_inc = 1  # N
  when 1 then col_inc = 1  # E
  when 2 then row_inc = -1 # S
  when 3 then col_inc = -1 # W
  end
  dist.times do
    row += row_inc
    col += col_inc
    loc = [row, col]
    if visited.include? loc
      puts row.abs + col.abs
      exit
    end
    visited <<  loc
  end
end
