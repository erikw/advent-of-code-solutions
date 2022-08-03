#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

scanners = []
ARGF.each_line do |line|
  case line
  when /-- scanner \d+ ---/
    scanners << []
  when /^$/

  else
    scanners[-1] << line.chomp.split(',').map(&:to_i)
  end
end

def orient(orient_idx, x, y, z)
  case orient_idx
  when 0
    [x,  y, z]
  when 1
    [x,  z, -y]
  when 2
    [x, -y, -z]
  when 3
    [x, -z, y]
  when 4
    [y,  x, -z]
  when 5
    [y,  z, x]
  when 6
    [y, -x, z]
  when 7
    [y, -z, -x]
  when 8
    [z,  x, y]
  when 9
    [z,  y, -x]
  when 10
    [z, -x, -y]
  when 11
    [z, -y, x]
  when 12
    [-x, y, -z]
  when 13
    [-x, z, y]
  when 14
    [-x, -y, z]
  when 15
    [-x, -z, -y]
  when 16
    [-y, x, z]
  when 17
    [-y, z, -x]
  when 18
    [-y, -x, -z]
  when 19
    [-y, -z, x]
  when 20
    [-z, x, -y]
  when 21
    [-z, y, x]
  when 22
    [-z, -x, y]
  when 23
    [-z, -y, -x]
  end
end

def merge(points_merged, points)
  (0...24).each do |orient_idx|
    points_oriented = points.map { |p| orient(orient_idx, *p) }
    distances = points_merged.to_a.product(points_oriented).map do |p1, p2|
      [p1[0] - p2[0], p1[1] - p2[1], p1[2] - p2[2]]
    end
    distances.each do |distance|
      points_mapped = points_oriented.map { |x, y, z| [x + distance[0], y + distance[1], z + distance[2]] }
      points_overlapping = points_merged & points_mapped.to_set
      next unless points_overlapping.size >= 12

      points_merged.merge(points_mapped)
      return true, distance
    end
  end
  false
end

points_merged = Set.new(scanners.delete_at(0))
distances = []
until scanners.empty?
  to_delete = []
  (0...scanners.length).reverse_each do |i|
    merged, distance = merge(points_merged, scanners[i])
    if merged
      distances << distance
      to_delete << scanners[i]
    end
  end
  to_delete.each do |sc|
    scanners.delete sc
  end
end

max_dist = distances.combination(2).map do |p1, p2|
  p1.zip(p2).flat_map { |a, b| (a - b).abs }.sum
end.max
puts max_dist
