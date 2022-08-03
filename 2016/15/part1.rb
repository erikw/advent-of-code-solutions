#!/usr/bin/env ruby
# frozen_string_literal: true

discs = ARGF.each_line.map { |l| l.scan(/ \d+/).map(&:to_i) }

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
