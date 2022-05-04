#!/usr/bin/env ruby

discs = ARGF.each_line.map { |l| l.scan(/ \d+/).map(&:to_i) }
discs << [11, 0]

(0...discs.length).each do |i|
  discs[i][1] = (discs[i][1] + 1 + i) % discs[i][0]
end

time = 0
until discs.map(&:last).all?(&:zero?)
  time += 1
  (0...discs.length).each do |i|
    discs[i][1] = (discs[i][1] + 1) % discs[i][0]
  end
end
puts time
