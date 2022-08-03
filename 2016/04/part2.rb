#!/usr/bin/env ruby
# frozen_string_literal: true

SEARCH = 'northpole object storage'
pattern = /([a-z]+(?:-[a-z]+)+)-(\d+)\[[a-z]+\]/
sector = ARGF.each_line.map { |l| l.match(pattern).captures }.select do |ename, sector_id|
  SEARCH == ename.each_char.map do |c|
    if c == '-'
      ' '
    else
      ((c.ord - 'a'.ord + sector_id.to_i) % ('z'.ord - 'a'.ord + 1) + 'a'.ord).chr
    end
  end.join
end.first[1]
puts sector
