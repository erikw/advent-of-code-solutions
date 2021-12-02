#!/usr/bin/env ruby

def s1
  horiz = 0
  depth = 0
  ARGF.each_line.map(&:split).map { |cmd, units| [cmd, units.to_i] }.each do |cmd, units|
    horiz += units if cmd == 'forward'
    depth -= units if cmd == 'up'
    depth += units if cmd == 'down'
  end
  puts horiz * depth
end

def s2
  horiz = 0
  depth = 0
  ARGF.each_line.map(&:split).map { |cmd, units| [cmd, units.to_i] }.each do |cmd, units|
    case cmd
    when 'forward'
      horiz += units
    when 'up'
      depth -= units
    when 'down'
      depth += units
    end
  end
  puts horiz * depth
end

# s1
s2
