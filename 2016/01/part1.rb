#!/usr/bin/env ruby
# frozen_string_literal: true

row = 0
col = 0
facing = 0
ARGF.readline.split(', ').map {|p| [p[0], p[1..].to_i] }.each do |turn, dist|
  facing = (facing + (turn == 'R' ? 1 : -1)) % 4
  case facing
  when 0 then row += dist # N
  when 1 then col += dist # E
  when 2 then row -= dist # S
  when 3 then col -= dist # W
  end
end
puts row.abs + col.abs
