#!/usr/bin/env ruby
# frozen_string_literal: true

IPATTERN = /(\w)(\d+)/

pos = 0 + 0i
waypoint = -1 + 10i
ARGF.each_line.map { |l| l.match(IPATTERN)[1..] }.each do |action, value|
  value = value.to_i
  case action
  when 'N'
    waypoint += Complex(-value, 0)
  when 'E'
    waypoint += Complex(0, value)
  when 'S'
    waypoint += Complex(value, 0)
  when 'W'
    waypoint += Complex(0, -value)
  when 'L'
    turns = value / 90
    waypoint *= Complex(0, 1)**turns
  when 'R'
    turns = value / 90
    waypoint *= Complex(0, -1)**turns
  when 'F'
    pos += value * waypoint
  end
end

puts pos.real.abs + pos.imag.abs
