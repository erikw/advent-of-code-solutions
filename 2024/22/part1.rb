#!/usr/bin/env ruby
# frozen_string_literal: true

DAILY_GENERATIONS = 2000

class Integer
  def mix(other)
    self ^ other
  end

  def prune
    # self % 16_777_216
    self & 0xFFFFFF
  end
end

sec_nums = ARGF.each_line.map(&:to_i)

DAILY_GENERATIONS.times do
  sec_nums.map! do |num|
    num = num.mix(num * 64).prune
    num = num.mix(num >> 5).prune
    num.mix(num * 2048).prune
  end
end

snum_sum = sec_nums.sum
puts snum_sum
