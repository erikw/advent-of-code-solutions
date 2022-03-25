#!/usr/bin/env ruby

nice = 0
ARGF.each_line.map(&:chomp).each do |string|
  repeated_pair = false
  pairs = {}
  string.chars.each_with_index.each_cons(2) do |x, y|
    pair = x[0] + y[0]
    repeated_pair = true if pairs.key?(pair) && pairs[pair][1] != x[1]
    pairs[pair] = [x[1], y[1]]
  end
  repeated_one = false
  string.chars.each_cons(3) do |a, _, c|
    repeated_one ||= a == c
  end
  nice += 1 if repeated_pair && repeated_one
end

puts nice
