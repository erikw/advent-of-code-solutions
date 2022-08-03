#!/usr/bin/env ruby
# frozen_string_literal: true

horiz = 0
depth = 0
aim = 0
ARGF.each_line.map(&:split).map { |cmd, units| [cmd, units.to_i] }.each do |cmd, units|
  case cmd
  when 'forward'
    horiz += units
    depth += aim * units
  when 'up'
    aim -= units
  when 'down'
    aim += units
  end
end
puts horiz * depth
