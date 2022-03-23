#!/usr/bin/env ruby

floor = 0
ARGF.readline.split('').each do |c|
  case c
  when '('
    floor += 1
  when ')'
    floor -= 1
  end
end
puts floor
