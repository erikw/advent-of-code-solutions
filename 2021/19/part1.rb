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

# scanners.combination(2) do |sc1, sc2|
# %w[z y x].each do |orient_dim|
# (0...4).each do |rot|
# [-1, 1].each do |dir|
# sc2_oriented = sc2.map do |x, y, z|
# case orient_dim
# when 'z'
# c = Complex(x, y) * Complex('i')**rot
# x_o = c.real
# y_o = c.imag
# z_o = z * dir
# when 'y'
# c = Complex(x, z) * Complex('i')**rot
# x_o = c.real
# y_o = y * dir
# z_o = c.imag
# when 'x'
# c = Complex(z, y) * Complex('i')**rot
# x_o = x * dir
# y_o = c.imag
# z_o = c.real
# end
# [x_o, y_o, z_o]
# end
## puts '=' * 20
## (0...sc2.length).each do |i|
## puts "odim: #{orient_dim}, rot: #{rot}, dir: #{dir}, sc2: #{sc2[i]}, sc2_o: #{sc2_oriented[i]}"
## end

# intersection = sc1.to_set & sc2_oriented.to_set
## next unless intersection.length >= 12
# next unless intersection.length >= 1

# puts '>' * 20
# puts "odim: #{orient_dim}, rot: #{rot}, dir: #{dir}:"
# pp intersection
## pp intersection if intersection.length >= 12
## pp intersection
# end
# end
# end
# end

# Hats off to https://www.reddit.com/r/adventofcode/comments/rjpf7f/comment/hp58zmu/?utm_source=share&utm_medium=web2x&context=3
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

def merged?(points_merged, points)
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
      return true
    end
  end
  false
end

points_merged = Set.new(scanners.delete_at(0))
until scanners.empty?
  to_delete = []
  (0...scanners.length).reverse_each do |i|
    next unless merged?(points_merged, scanners[i])

    to_delete << scanners[i]
  end
  to_delete.each do |sc|
    scanners.delete sc
  end
end
puts points_merged.size
