#!/usr/bin/env ruby
# frozen_string_literal: true

jumps = ARGF.each_line.map(&:to_i)

pos = 0
count = 0
while pos.between?(0, jumps.length - 1)
  jumps[pos] += 1
  pos += jumps[pos] - 1
  count += 1
end
puts count
