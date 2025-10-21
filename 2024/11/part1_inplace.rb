#!/usr/bin/env ruby
# frozen_string_literal: true

# BLINKS = 1
# BLINKS = 6
BLINKS = 25
MUL_FACT = 2024

def blink(stones)
  i = 0
  while i < stones.size
    stone = stones[i]
    if stone == '0'
      stones[i] = '1'
      i += 1
    elsif stone.length.even?
      mid = stone.length / 2
      left = stone[...mid]
      right = stone[mid...].to_i.to_s
      stones.insert(i, left)
      stones[i + 1] = right
      i += 2
    else
      stones[i] = (stone.to_i * MUL_FACT).to_s
      i += 1
    end
  end
end

stones = ARGF.read.split

BLINKS.times do
  blink(stones)
end

puts stones.size
