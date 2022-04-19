#!/usr/bin/env ruby

pattern = /((?:[a-z]+-)+)(\d+)\[([a-z]+)\]/
a = ARGF.each_line.map { |l| l.match(pattern).captures }.select do |ename, _sector_id, checksum|
  ename.delete('-').chars.tally.to_a.sort_by { |c, f| [-f, c] }.map(&:first).join.start_with?(checksum)
end.sum { |_, sector_id, _| sector_id.to_i }
puts a
