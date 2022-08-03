#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

# instructions = ARGF.readlines.map { |l| l.chomp.split }
# computer = Computer.new('a' => 1)
# puts computer.execute(instructions).registers['h']

# Attempted translation in analysis.txt and translated.txt, however see
# https://www.reddit.com/r/adventofcode/comments/7lms6p/comment/drngit2/
# Checking how many numbers in steps of 17 in the range [B, C] are composite (non-prime)
B = 106_500
C = B + 17_000

h = 0
(B...(C + 1)).step(17) do |i|
  (2...i).each do |j|
    if i % j == 0
      h += 1
      break
    end
  end
end
puts h
