#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# SIDE = 11
SIDE = 1000
CLAIM_PATTERN = /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

fabric = Array.new(SIDE) { Array.new(SIDE) }
nonoverlapping = Set.new

ARGF.each_line do |line|
  id, left, top, wide, tall = line.match(CLAIM_PATTERN)[1..].map(&:to_i)
  nonoverlapping << id
  (top...(top + tall)).each do |row|
    (left...(left + wide)).each do |col|
      if fabric[row][col].nil?
        fabric[row][col] = id
      else
        nonoverlapping.delete(id)
        nonoverlapping.delete(fabric[row][col])
      end
    end
  end
end

puts nonoverlapping.to_a.first
