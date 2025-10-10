#!/usr/bin/env ruby
# frozen_string_literal: true

MUL_PATTERN = /(?<=mul\()\d{1,3},\d{1,3}(?=\))/

mul_nums = ARGF.each_line.map do |l|
  l.scan(MUL_PATTERN)
end.flatten
mul_sum = mul_nums.flat_map { |s| s.split(',') }.map(&:to_i).each_slice(2).map { |a, b| a * b }.sum
puts mul_sum
