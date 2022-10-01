#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

numbers = ARGF.each_line.map(&:to_i)
num_invalid = first_invalid(numbers)

# BF
(0...numbers.length).each do |i|
  sum = 0
  min = Float::INFINITY
  max = 0
  (i...numbers.length).each do |j|
    min = [min, numbers[j]].min
    max = [max, numbers[j]].max
    sum += numbers[j]

    if j > i && sum == num_invalid
      puts min + max
      exit
    elsif sum > num_invalid
      break
    end
  end
end
