#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

instructions = ARGF.each_line.map { |l| l.chomp.split }
# puts Computer.new.execute(instructions).registers[0]

# Hats off to https://www.reddit.com/r/adventofcode/comments/a7j9zc/comment/ec45g4d/
a = instructions[22][2].to_i
b = instructions[24][2].to_i
n = 836 + 22 * a + b
sqn = (n**0.5).to_i
ans = (1...(sqn + 1)).map do |d|
  n % d == 0 ? d + n / d : 0
end.sum
ans = sqn**2 == n ? ans - sqn : ans
puts ans
