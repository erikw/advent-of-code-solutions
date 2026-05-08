#!/usr/bin/env ruby
# frozen_string_literal: true

REPEAT_REG = /^(\d+)\1+$/

ranges = ARGF.readline(chomp: true).split(',').map { |r| r.split('-').map(&:to_i) }

inv_sum = ranges.sum do |first, last|
  (first..last).sum do |pid|
    pid.to_s.match?(REPEAT_REG) ? pid : 0
  end
end

puts inv_sum
