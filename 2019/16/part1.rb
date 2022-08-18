#!/usr/bin/env ruby
# frozen_string_literal: true

# PHASES = 4
PHASES = 100

KEEP_DIGITS = 8

BASE_PATTERN = [0, 1, 0, -1]

def fft(input, phases = 1)
  output = Array.new(input.length)
  patterns = Array.new(input.length)
  (0...input.length).each do |i|
    patterns[i] = BASE_PATTERN.map do |p|
      [p] * (i + 1)
    end.flatten.rotate.cycle.take(input.length)
  end

  phases.times do
    (0...input.length).each do |i|
      v = input.zip(patterns[i]).map { |a, b| a * b }.sum
      output[i] = v.abs % 10
    end
    input = output
  end
  output
end

signal = ARGF.readline.chomp.each_char.map(&:to_i)
puts fft(signal, PHASES)[0, KEEP_DIGITS].join
