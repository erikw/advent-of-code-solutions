#!/usr/bin/env ruby

require 'logger'

l = Logger.new(STDOUT)
#l.level = Logger::DEBUG
l.level = Logger::INFO
l.formatter = proc do |severity, datetime, progname, msg|
  "#{msg}\n"
end


floor = ARGF.each_line.map { |line| line.chomp.chars }

l.debug "Initial state:"
floor.each do|row|
  l.debug row.join
end
l.debug

steps = 0
loop do
  moved = false

  # East
  floor_new = Array.new.tap do |a|
    floor.each {|row| a << row.dup }
  end

  (0...floor.length).each do |row|
    (0...floor[0].length).each do |col|
      col_next = (col+1) % floor[0].length
      if floor[row][col] == '>' && floor[row][col_next] == '.'
        floor_new[row][col] = '.'
        floor_new[row][col_next] = '>'
        moved = true
      end
    end
  end
  floor = floor_new

  # South
  floor_new = Array.new.tap do |a|
    floor.each {|row| a << row.dup }
  end
  (0...floor.length).each do |row|
    (0...floor[0].length).each do |col|
      row_next = (row+1) % floor.length
      if floor[row][col] == 'v' && floor[row_next][col] == '.'
        floor_new[row][col] = '.'
        floor_new[row_next][col] = 'v'
        moved = true
      end
    end
  end
  floor = floor_new

  steps += 1

  l.debug "Afer #{steps} step:"
  floor.each do|row|
    l.debug row.join
  end
  l.debug

  break unless moved
end
puts steps
