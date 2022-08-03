#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'array'

positions = gets.split(',').map(&:to_i)
avg = positions.avg

cost_floor = positions.map do |pos|
  start, stop = [pos, avg.floor].sort
  (start...stop).map { |n| n - start + 1 }.sum
end.sum.to_i

cost_ceil = positions.map do |pos|
  start, stop = [pos, avg.ceil].sort
  (start...stop).map { |n| n - start + 1 }.sum
end.sum.to_i

puts [cost_floor, cost_ceil].min
