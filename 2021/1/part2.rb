#!/usr/bin/env ruby

measurements = ARGF.each_line.map(&:to_i)
count = (3...measurements.length).count do |i|
  win = measurements[i - 2] + measurements[i - 1] + measurements[i]
  win_prev = measurements[i - 3] + measurements[i - 2] + measurements[i - 1]
  win > win_prev
end
puts count
