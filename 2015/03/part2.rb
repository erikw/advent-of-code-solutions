#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def deliver(dirs, visited)
  verti = 0
  horiz = 0
  dirs.each do |dir|
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
end

visited = Set.new([[0, 0]])
dirs_santa, dirs_robo = ARGF.readline.split('').partition.with_index { |_, i| i.even? }
deliver dirs_santa, visited
deliver dirs_robo, visited
puts visited.size
