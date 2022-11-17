#!/usr/bin/env ruby
# frozen_string_literal: true

def most_common(array, col)
  array.transpose.map { |colchars| (colchars.sum / colchars.length.to_f).round }[col]
end

report = ARGF.each_line.map { |line| line.chomp.split('').map(&:to_i) }

i = 0
r = report
until r.length == 1
  r = r.select { |n| n[i] == most_common(r, i) }
  i += 1
end
oxygen_rate = r[0].join.to_i(2)

i = 0
r = report
until r.length == 1
  r = r.select { |n| n[i] == (most_common(r, i) + 1) % 2 }
  i += 1
end
scrub_rate = r[0].join.to_i(2)

puts oxygen_rate * scrub_rate
