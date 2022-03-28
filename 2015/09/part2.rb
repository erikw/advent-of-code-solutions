#!/usr/bin/env ruby

distance = Hash.new { |h, k| h[k] = {} }
ARGF.each_line.map(&:split).each do |city1, _, city2, _, dist|
  distance[city1][city2] = dist.to_i
  distance[city2][city1] = dist.to_i
end

dist = distance.keys.permutation.map do |perm|
  perm.each_cons(2).sum { |from, to| distance[from][to] }
end.max
puts dist
