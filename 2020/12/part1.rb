#!/usr/bin/env ruby
# frozen_string_literal: true

IPATTERN = /(\w)(\d+)/

pos = 0 + 0i
dir = 0 + 1i
ARGF.each_line.map { |l| l.match(IPATTERN)[1..] }.each do |action, value|
  value = value.to_i
  case action
  when 'N'
    pos += Complex(-value, 0)
  when 'E'
    pos += Complex(0, value)
  when 'S'
    pos += Complex(value, 0)
  when 'W'
    pos += Complex(0, -value)
  when 'L'
    turns = value / 90
    dir *= Complex(0, 1)**turns
  when 'R'
    turns = value / 90
    dir *= Complex(0, -1)**turns
  when 'F'
    pos += value * dir
  end
end

puts pos.real.abs + pos.imag.abs
