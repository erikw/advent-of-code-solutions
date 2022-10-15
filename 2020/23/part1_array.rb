#!/usr/bin/env ruby
# frozen_string_literal: true

# Hats off to https://www.reddit.com/r/adventofcode/comments/kimluc/comment/ggrzza7/?utm_source=share&utm_medium=web2x&context=3
# The array cups has index being the cup label and the value is the clock-wise next neighbour.

require 'set'

# MOVES = 10
MOVES = 100

def cups_string(cups, start)
  cur = start
  values = []
  loop do
    values << cur
    cur = cups[cur]

    break if cur == start
  end
  values.join(' ')
end

numbers = ARGF.readline.chomp.split('').map(&:to_i)
min, max = numbers.minmax

cups = Array.new(numbers.length + 1)
numbers.each_cons(2) do |n1, n2|
  cups[n1] = n2
end
cups[numbers.last] = numbers.first

cur = numbers.first

MOVES.times do
  itr = cur

  picked = Set.new
  3.times do
    itr = cups[itr]
    picked << itr
  end

  dest = cur - 1
  dest = max if dest < min

  while picked.include?(dest)
    dest -= 1
    dest = max if dest < min
  end

  nxt = cups[itr] # after the 3 picked cups
  cups[itr] = cups[dest] # last of 3 picked point to dest's next
  cups[dest] = cups[cur] # dest's next is first of the 3 picked
  cups[cur] = nxt
  cur = nxt
end

numbers = []
itr = cups[1]
until itr == 1
  numbers << itr
  itr = cups[itr]
end

puts numbers.join
