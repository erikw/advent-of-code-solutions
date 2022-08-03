#!/usr/bin/env ruby
# frozen_string_literal: true

PAIRS = 5_000_000
FACTOR_A = 16_807
FACTOR_B = 48_271
DENOMINATOR = 2_147_483_647
MULTIPLE_A = 4
MULTIPLE_B = 8

def gen(factor, demoninator, multiple, prev_value, cache)
  unless cache.key?(prev_value)
    cache[prev_value] = prev_value
    loop do
      cache[prev_value] = cache[prev_value] * factor % demoninator
      break if (cache[prev_value] % multiple) == 0
    end
  end
  cache[prev_value]
end

def matches16b(a, b)
  a & 0xFFFF == b & 0xFFFF
end

val_a, val_b = ARGF.each_line.map { |line| line.split.last.to_i }

matching = 0
cache_a = {}
cache_b = {}
PAIRS.times do
  val_a = gen(FACTOR_A, DENOMINATOR, MULTIPLE_A, val_a, cache_a)
  val_b = gen(FACTOR_B, DENOMINATOR, MULTIPLE_B, val_b, cache_b)
  matching += 1 if matches16b(val_a, val_b)
end
puts matching
