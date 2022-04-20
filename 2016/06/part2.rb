#!/usr/bin/env ruby

msg = ARGF.readlines.map { |l| l.chomp.split('') }.transpose.map do |chars|
  chars.tally.min_by(&:last).first
end.join
puts msg
