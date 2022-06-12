#!/usr/bin/env ruby

require 'set'
require_relative '../10/knot_hash'

GRID_DIM = 128
DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def find_component(hashes, row, col)
  component = Set.new
  que = Thread::Queue.new([[row, col]])

  until que.empty?
    r, c = que.pop
    next if component.include?([r, c]) ||
            !r.between?(0, hashes.length - 1) ||
            !c.between?(0, hashes[0].length - 1) ||
            hashes[r][c] == '0'

    component << [r, c]
    DIRECTIONS.each { |dr, dc| que << [r + dr, c + dc] }
  end
  component
end

def collect_ones(hashes)
  ones = Set.new
  hashes.each_with_index do |hash, row|
    hash.each_with_index do |digit, col|
      next if digit == '0'

      ones << [row, col]
    end
  end
  ones
end

def connected_components(hashes)
  components = []
  ones = collect_ones(hashes)

  until ones.empty?
    row, col = ones.to_a.first
    ones.delete([row, col])
    component = find_component(hashes, row, col)
    components << component
    ones -= component
  end
  components
end

key = ARGF.readline.chomp
hasher = KnotHash::KnotHasher.new
hashes = (0...GRID_DIM).map do |i|
  input = "#{key}-#{i}".each_char.map(&:ord)
  hash =  hasher.hash(input)
  hash.each_char.map { |c| c.hex.to_s(2).rjust(4, '0') }.join.chars
end

puts connected_components(hashes).length
