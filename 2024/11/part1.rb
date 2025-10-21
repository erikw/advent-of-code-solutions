#!/usr/bin/env ruby
# frozen_string_literal: true

# BLINKS = 1
# BLINKS = 6
BLINKS = 25
MUL_FACT = 2024

def blink(stones)
  stones_next = []
  stones.each do |stone|
    if stone == '0'
      stones_next << '1'
    elsif stone.length.even?
      mid = stone.length / 2
      left = stone[...mid]
      right = stone[mid...].to_i.to_s
      stones_next.push(left, right)
    else
      stones_next << (stone.to_i * MUL_FACT).to_s
    end
  end
  stones_next
end

stones = ARGF.read.split

BLINKS.times do
  stones = blink(stones)
end

puts stones.size
