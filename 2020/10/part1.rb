#!/usr/bin/env ruby
# frozen_string_literal: true

def jolt_differencdes(chain)
  diffs = Hash.new(0)
  diffs[chain.first] += 1
  diffs[3] += 1
  (1...chain.length).each do |i|
    diff = chain[i] - chain[i - 1]
    diffs[diff] += 1
  end
  diffs
end

adapters = ARGF.each_line.map(&:to_i).sort

diffs = jolt_differencdes(adapters)
puts diffs[1] * diffs[3]
