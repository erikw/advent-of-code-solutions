#!/usr/bin/env ruby
# frozen_string_literal: true

DIAL_START = 50
DIGITS = 100

rotations = ARGF.each_line(chomp: true).map { |r| [r[0], r[1..].to_i] }

dial = DIAL_START
zeroes = rotations.map do |dir, len|
  case dir
  when 'L'
    dial -= len
  when 'R'
    dial += len
  end
  dial %= DIGITS
end.count(&:zero?)
puts zeroes
