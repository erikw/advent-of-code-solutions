#!/usr/bin/env ruby

checksum = ARGF.each_line.sum do |line|
  line.split.map(&:to_i).combination(2).select { |a, b| a % b == 0 || b % a == 0 }.first.sort.reverse.inject(&:/)
end
puts checksum
