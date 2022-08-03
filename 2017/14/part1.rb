#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../10/knot_hash'

GRID_DIM = 128

key = ARGF.readline.chomp
hasher = KnotHash::KnotHasher.new
ones = (0...GRID_DIM).sum do |i|
  input = "#{key}-#{i}".each_char.map(&:ord)
  hash =  hasher.hash(input)
  bin = hash.each_char.map { |c| c.hex.to_s(2).rjust(4, '0') }.join
  bin.each_char.count { |d| d == '1' }
end
puts ones
