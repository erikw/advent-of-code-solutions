#!/usr/bin/env ruby
# frozen_string_literal: true

# Hatts off to https://www.reddit.com/r/adventofcode/comments/kc4njx/comment/gfnbwzc/?utm_source=share&utm_medium=web2x&context=3

def ext_gcd(a, b, values)
  d = a

  if b.zero?
    values[:x] = 1
    values[:y] = 0
  else
    d = ext_gcd(b, a % b, values)

    x = values[:x]
    y = values[:y]
    values[:x] = y
    values[:y] = x - (a / b) * y
  end

  d
end

# Implementation stolen from https://linuxtut.com/en/f652d4941298a9842dfc/
def chineese_reminder(b, m)
  r = 0
  mM = 1
  b.zip(m) do |bi, mi|
    val = {}
    d = ext_gcd(mM, mi, val)
    p = val[:x]
    q = val[:y]
    return [0, -1] if (bi - r) % d != 0

    tmp = (bi - r) / d * p % (mi / d)
    r += mM * tmp
    mM *= mi / d
  end

  [r % mM, mM]
end

_time_arrival = ARGF.readline.to_i
busses = ARGF.readline.chomp.split(',').map(&:to_i).each_with_index.reject { |t, _i| t == 0 } # [bus_id, index]

mods = busses.map(&:first)
remainders = busses.map { |b, i| (-i) % b }

puts chineese_reminder(remainders, mods)[0]
