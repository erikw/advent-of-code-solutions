#!/usr/bin/env ruby
# frozen_string_literal: true

adapters = ARGF.each_line.map(&:to_i).sort
adapters.unshift(0)
adapters << adapters.last + 3

# dp[i] is the number of ways a chain can be constructed ending on adapter[i].
dp = Array.new(adapters.length, 0)
dp[0] = 1

(1...dp.length).each do |i|
  j = i - 1
  # Sum up different possibilities (the adapter[j]s) to end the chain at adapter[i].
  while j >= 0 && (adapters[i] - adapters[j]) <= 3
    dp[i] += dp[j]
    j -= 1
  end
end
puts dp.last
