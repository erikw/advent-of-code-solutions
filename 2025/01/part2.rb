#!/usr/bin/env ruby
# frozen_string_literal: true

DIAL_START = 50
DIGITS = 100

rotations = ARGF.each_line(chomp: true).map { |r| [r[0], r[1..].to_i] }

dial = DIAL_START
zeroes = rotations.sum do |dir, len|
  case dir
  when 'L'
    diff = dial - len
    zeroes = len / DIGITS
    # Leftover movement after full turns
    zeroes += 1 if dial != 0 && (len % DIGITS) >= dial
  when 'R'
    diff = dial + len
    zeroes = diff / DIGITS
  end
  dial = diff % DIGITS
  zeroes
end

puts zeroes
