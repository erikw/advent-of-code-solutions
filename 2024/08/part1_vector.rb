#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_EMPTY = '.'

def euclidean_distance(point1, point2)
  Math.sqrt((point2[0] - point1[0])**2 + (point2[1] - point1[1])**2)
end

map = ARGF.each_line(chomp: true).to_a
height = map.size
width = map[0].size
antennas_by_freq = Hash.new { |h, k| h[k] = Set.new }
map.each_with_index do |line, y|
  line.each_char.with_index do |sym, x|
    antennas_by_freq[sym] << [x, y] unless sym == SYM_EMPTY
  end
end

antinodes = antennas_by_freq.values.flat_map do |antennas|
  antennas.to_a.combination(2).flat_map do |a1, a2|
    a1, a2 = a2, a1 if a2[0] < a1[0]
    dist = euclidean_distance(a1, a2)
    dir = [a2[0] - a1[0], a2[1] - a1[1]]
    dir_norm = [dir[0] / dist, dir[1] / dist]
    deltas = [(dir_norm[0] * dist), (dir_norm[1] * dist)]

    valid = []
    antinode1 = [(a1[0] - deltas[0].round), (a1[1] - deltas[1]).round]
    antinode2 = [(a2[0] + deltas[0].round), (a2[1] + deltas[1]).round]
    valid << antinode1 if antinode1[0].between?(0, height - 1) && antinode1[1].between?(0, width - 1)
    valid << antinode2 if antinode2[0].between?(0, height - 1) && antinode2[1].between?(0, width - 1)
    valid
  end
end.uniq

puts antinodes.size
