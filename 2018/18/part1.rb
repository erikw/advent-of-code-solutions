#!/usr/bin/env ruby

require_relative 'lib'

MINUTES = 10

acres = ARGF.each_line.map(&:chomp)

MINUTES.times do
  acres = iterate_acres(acres)
end

wood = acres.join.chars.count(SYM_TREES)
lumber = acres.join.chars.count(SYM_LUMBER)
puts wood * lumber
