#!/usr/bin/env ruby
# frozen_string_literal: true

points = ARGF.each_line.with_index.map do |line, i|
  p, v, a = line.chomp.gsub(/[pva=<>]/, '').split.map do |cords|
    cords.split(',').map(&:to_i)
  end
  { i:, p:, v:, a: }
end

puts points.min_by { |p| p[:a].map(&:abs).sum }[:i]
