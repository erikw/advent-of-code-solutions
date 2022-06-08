#!/usr/bin/env ruby

jumps = ARGF.each_line.map(&:to_i)

pos = 0
count = 0
while pos.between?(0, jumps.length - 1)
  diff = jumps[pos] >= 3 ? -1 : 1
  jumps[pos] += diff
  pos += jumps[pos] - diff
  count += 1
end
puts count
