#!/usr/bin/env ruby

checksum = ARGF.each_line.map do |line|
  tally = line.chomp.chars.tally
  twos = tally.values.include?(2) ? 1 : 0
  threes = tally.values.include?(3) ? 1 : 0
  [twos, threes]
end.inject do |sum, c|
  sum[0] += c[0]
  sum[1] += c[1]
  sum
end.inject(&:*)

puts checksum
