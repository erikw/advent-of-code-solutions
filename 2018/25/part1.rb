#!/usr/bin/env ruby
# frozen_string_literal: true

# https://cp-algorithms.com/data_structures/disjoint_set_union.html
class DisjointSetUnion
  def initialize
    @parent = {}
    @size = {}
  end

  def make_set(v)
    @parent[v] = v
    @size[v] = 1
    v
  end

  def find(v)
    @parent[v] = @parent[v] == v ? v : find(@parent[v])
  end

  def union(a, b)
    sa = find(a) || make_set(a)
    sb = find(b) || make_set(b)
    unless sa == sb
      sa, sb = sb, sa if @size[sa] < @size[sb]
      @parent[sb] = sa
      @size[sa] += @size[sb]
      @size.delete(sb)
    end
  end

  def size
    @size.length
  end
end

def manhattan_distance(pa, pb)
  pa.zip(pb).map { |x| x.inject(&:-).abs }.sum
end

points = ARGF.each_line.map { |l| l.split(',').map(&:to_i) }

constellations = DisjointSetUnion.new
points.each { |p| constellations.make_set(p) }
points.combination(2) do |pa, pb|
  constellations.union(pa, pb) if manhattan_distance(pa, pb) <= 3
end

puts constellations.size
