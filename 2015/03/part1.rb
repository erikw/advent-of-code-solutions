#!/usr/bin/env ruby

require 'set'

verti = 0
horiz = 0
visited = Set.new([[horiz, verti]])
ARGF.readline.split('').each do |dir|
  case dir
  when '<'
    horiz -= 1
  when '>'
    horiz += 1
  when '^'
    verti -= 1
  when 'v'
    verti += 1
  end
  visited << [horiz, verti]
end
puts visited.size
