#!/usr/bin/env ruby

# Distance is the same as multi-dim manhattan distance, but half.
# Ref: https://www.redblobgames.com/grids/hexagons/#distances
def distance_origin(r, s, q)
  (r.abs + s.abs + q.abs) / 2
end

# Switch to Cube coordinates (flat view).
# Ref: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
max_dist = 0
r = 0
s = 0
q = 0
ARGF.readline.chomp.split(',').each do |dir|
  case dir
  when 'n'
    s += 1
    r -= 1
  when 'ne'
    q += 1
    r -= 1
  when 'se'
    q += 1
    s -= 1
  when 's'
    r += 1
    s -= 1
  when 'sw'
    q -= 1
    r += 1
  when 'nw'
    q -= 1
    s += 1
  end
  max_dist = [max_dist, distance_origin(r, s, q)].max
end

puts max_dist
