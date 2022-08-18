#!/usr/bin/env ruby
# frozen_string_literal: true

PHASES = 100

KEEP_DIGITS = 8
INPUT_REPEAT = 10_000
BASE_PATTERN = [0, 1, 0, -1]
OFFSET_LEN = 7

# Hats off to https://www.reddit.com/r/adventofcode/comments/ebf5cy/comment/fb4awi4/?utm_source=share&utm_medium=web2x&context=3
# The key insights are
# * we can skip computing values before the offset
# * The offset is so large, that to calculate each digit in a phase is just the sum in that unitriangular matrix.
def fft(input, phases = 1)
  output = input.dup
  phases.times do
    partial_sum = output.sum
    (0...input.length).each do |i|
      s = partial_sum
      partial_sum -= output[i]
      output[i] = s.abs % 10
    end
  end
  output
end

signal = ARGF.readline.chomp.each_char.map(&:to_i) * INPUT_REPEAT
offset = signal[0, OFFSET_LEN].join.to_i
signal = signal[offset..]
puts fft(signal, PHASES)[0, KEEP_DIGITS].join
