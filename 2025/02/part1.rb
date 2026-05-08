#!/usr/bin/env ruby
# frozen_string_literal: true

ranges = ARGF.readline(chomp: true).split(',').map { |r| r.split('-').map(&:to_i) }

inv_sum = ranges.map do |first, last|
  (first..last).select do |pid|
    pids = pid.to_s
    next false if (pids.length % 2).odd?

    mid = pids.length / 2
    pids[0...mid] == pids[mid...]
  end
end.flatten.sum

puts inv_sum
