#!/usr/bin/env ruby

# PAIRS = 5
PAIRS = 40_000_000
FACTOR_A = 16_807
FACTOR_B = 48_271
DENOMINATOR = 2_147_483_647

def gen(factor, demoninator, prev_value, cache)
  cache[prev_value] = prev_value * factor % demoninator unless cache.key?(prev_value)
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
  val_a = gen(FACTOR_A, DENOMINATOR, val_a, cache_a)
  val_b = gen(FACTOR_B, DENOMINATOR, val_b, cache_b)
  matching += 1 if matches16b(val_a, val_b)
end
puts matching
