#!/usr/bin/env ruby
# frozen_string_literal: true

DAILY_GENERATIONS = 2000
CHANGE_WINDOW = 4
PRUNE_MASK = 0xFFFFFF

def secret_next(n)
  n ^= n << 6 & PRUNE_MASK
  n ^= n >> 5 & PRUNE_MASK
  n ^ n << 11 & PRUNE_MASK
end

sec_nums = ARGF.each_line.map(&:to_i)
bananas = Hash.new(0)

sec_nums.each do |num|
  prices = [num % 10]
  chngs = []
  DAILY_GENERATIONS.times do |i|
    num = secret_next(num)
    prices << num % 10
    chngs << prices.last - prices[i]
  end

  seen_seqs = Set.new
  chngs.each_cons(CHANGE_WINDOW).with_index do |chng_seq, i|
    next if seen_seqs.include?(chng_seq)

    seen_seqs << chng_seq
    price = prices[i + 4]
    bananas[chng_seq] += price
  end
end

max_bananas = bananas.values.max
puts max_bananas
