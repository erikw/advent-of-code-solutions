#!/usr/bin/env ruby

valid = ARGF.each_line.map { |l| l.split.map(&:to_i) }.transpose.flatten.each_slice(3).count do |a, b, c|
  a + b > c && a + c > b && b + c > a
end
puts valid
