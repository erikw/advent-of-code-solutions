#!/usr/bin/env ruby
# frozen_string_literal: true

class Cuboid
  attr_reader :range_x, :range_y, :range_z
  attr_accessor :sign

  def initialize(sign, range_x, range_y, range_z)
    @sign = sign
    @range_x = range_x
    @range_y = range_y
    @range_z = range_z
  end

  def volume
    @sign *
      (@range_x.inject(&:-).abs+1) *
      (@range_y.inject(&:-).abs+1) *
      (@range_z.inject(&:-).abs+1)
  end

  def intersection(other)
    sign = other.sign * -1
    int_x = get_intersection(@range_x, other.range_x)
    int_y = get_intersection(@range_y, other.range_y)
    int_z = get_intersection(@range_z, other.range_z)
    if [int_x, int_y, int_z].any?(&:nil?)
      nil
    else
      Cuboid.new(sign, int_x, int_y, int_z)
    end
  end

  def to_s
    "Cuboid(#{@sign == -1 ? '-' : '+'}, #{@range_x}, #{@range_y}, #{@range_z})"
  end
  alias inspect to_s


  private
  def get_intersection(range_a, range_b)
    start_max = [range_a[0], range_b[0]].max
    end_max = [range_a[1], range_b[1]].min
    if start_max <= end_max
      [start_max, end_max]
    else
      nil
    end
  end
end

cuboids = []
ARGF.each_line.map do |line|
  mode, rest = line.split
  sign = (mode == "on") ? 1 : -1
  range_x, range_y, range_z = rest.split(',').map do |rangestr|
    rangestr[2..].split('..').map(&:to_i)
  end
  cuboid = Cuboid.new(sign, range_x, range_y, range_z)

  cuboids_new = []
  cuboids.each do |cuboid_other|
    cub_int = cuboid.intersection(cuboid_other)
    cuboids_new << cub_int unless cub_int.nil?
  end
  cuboids.concat(cuboids_new)

  if sign == 1
    cuboids << cuboid
  end
end

puts cuboids.map(&:volume).sum
