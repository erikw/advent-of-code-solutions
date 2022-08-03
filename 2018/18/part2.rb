#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'
require 'set'

MINUTES = 1_000_000_000

acres = ARGF.each_line.map(&:chomp)

acres_seen = Set.new
min = 0
until acres_seen.include?(acres)
  acres_seen << acres
  acres = iterate_acres(acres)
  min += 1
end

min *= MINUTES / min
(min...MINUTES).each do
  acres = iterate_acres(acres)
end

wood = acres.join.chars.count(SYM_TREES)
lumber = acres.join.chars.count(SYM_LUMBER)
puts wood * lumber
