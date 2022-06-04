#!/usr/bin/env ruby

2.times { ARGF.readline }

viable = ARGF.each_line.map(&:split).combination(2).map do |node1, node2|
  n = 0
  n += 1 if node1[2].to_i != 0 && node1[2].to_i <= node2[3].to_i
  n += 1 if node2[2].to_i != 0 && node2[2].to_i <= node1[3].to_i
  n
end.sum

puts viable
