#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

MOVES = 10_000_000
CUPS = 1_000_000

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

cups = Array.new(CUPS + 1)
numbers.each_cons(2) do |n1, n2|
  cups[n1] = n2
end
cups[numbers.last] = max + 1

((max + 1)..CUPS).each do |num|
  cups[num] = num + 1
end
cups[-1] = numbers.first

cur = numbers.first
max = CUPS

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

next1 = cups[1]
next2 = cups[next1]
puts next1 * next2
