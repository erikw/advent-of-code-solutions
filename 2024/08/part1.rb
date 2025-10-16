#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_EMPTY = '.'

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
  antennas.to_a.combination(2).flat_map do |(x1, y1), (x2, y2)|
    x1, y1, x2, y2 = [x2, y2, x1, y1] if x2 < x1

    dx = x2 - x1
    dy = y2 - y1
    antinode1 = [x1 - dx, y1 - dy]
    antinode2 = [x2 + dx, y2 + dy]

    [antinode1, antinode2].select do |x, y|
      x.between?(0, width - 1) && y.between?(0, height - 1)
    end
  end
end.uniq

puts antinodes.size
