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

# [[[sec_num, price, chng]]]
monkey_biz = sec_nums.map { |num| [[num, num % 10, nil]] }

(DAILY_GENERATIONS - 0).times do
  monkey_biz.each do |buyer|
    num, price, _chng = buyer.last
    num_n = secret_next(num)
    price_n = num_n % 10
    change_n = price_n - price
    buyer << [num_n, price_n, change_n]
  end
end

bananas = Hash.new(0)
monkey_biz.each do |buyer|
  seen_chngs = Set.new
  buyer[1..].each_cons(CHANGE_WINDOW) do |gens|
    chngs = gens.map(&:last)
    next if seen_chngs.include?(chngs)

    seen_chngs << chngs
    price = gens.last[1]
    bananas[chngs] += price
  end
end

max_bananas = bananas.values.max
puts max_bananas
