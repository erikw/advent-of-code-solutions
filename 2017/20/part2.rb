#!/usr/bin/env ruby
# frozen_string_literal: true

ITERATIONS = 39 # Empirically found

def manhattan_distance(p1, p2)
  (p1[:p][0] - p2[:p][0]).abs +
    (p1[:p][1] - p2[:p][1]).abs +
    (p1[:p][2] - p2[:p][2]).abs
end

points = {}
ARGF.each_line.with_index do |line, i|
  p, v, a = line.chomp.gsub(/[pva=<>]/, '').split.map do |cords|
    cords.split(',').map(&:to_i)
  end
  points[i] = { i:, p:, v:, a: }
end

ITERATIONS.times do
  points.values.each do |point|
    point[:v][0] += point[:a][0]
    point[:v][1] += point[:a][1]
    point[:v][2] += point[:a][2]

    point[:p][0] += point[:v][0]
    point[:p][1] += point[:v][1]
    point[:p][2] += point[:v][2]
  end

  points.values.combination(2).select do |p1, p2|
    manhattan_distance(p1, p2) == 0
  end.flatten.map { |p| p[:i] }.each do |i|
    points.delete(i)
  end
end

puts points.size
