#!/usr/bin/env ruby
# frozen_string_literal: true

SYM_EMPTY = '.'

# Returns all integer points along a directed line until the map boundary
def directed_line_points(x, y, dx, dy, width, height)
  points = []
  loop do
    x += dx
    y += dy
    break unless x.between?(0, width - 1) && y.between?(0, height - 1)

    points << [x, y]
  end
  points
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

antinodes = Set.new
antennas_by_freq.each_value do |antennas|
  antennas.to_a.combination(2) do |(x1, y1), (x2, y2)|
    x1, y1, x2, y2 = [x2, y2, x1, y1] if x2 < x1

    dx = (x2 - x1)
    dy = (y2 - y1)

    antinodes.merge([[x1, y1], [x2, y2]])
    antinodes.merge(directed_line_points(x1, y1, -dx, -dy, width, height))
    antinodes.merge(directed_line_points(x1, y1, dx, dy, width, height))
  end
end

puts antinodes.size
