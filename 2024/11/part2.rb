#!/usr/bin/env ruby
# frozen_string_literal: true

BLINKS = 75
MUL_FACT = 2024

def blink(stone_counts)
  stone_counts_new = Hash.new(0)
  stone_counts.each do |stone, count|
    if stone == '0'
      stone_counts_new['1'] += count
    elsif stone.length.even?
      mid = stone.length / 2
      left = stone[...mid]
      right = stone[mid...].to_i.to_s
      stone_counts_new[left] += count
      stone_counts_new[right] += count
    else
      stone_m = (stone.to_i * MUL_FACT).to_s
      stone_counts_new[stone_m] += count
    end
  end
  stone_counts_new
end

stone_counts = ARGF.read.split.tally.tap { |h| h.default = 0 }

BLINKS.times do |i|
  stone_counts = blink(stone_counts)
end

puts stone_counts.values.sum
