#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def smaller_than(values, row1, col1, row2, col2)
  # puts "Testing values[#{row1}][#{col1}]=#{values[row1][col1]} against values[#{row2}][#{col2}]=#{values[row2][col2]}"
  if row2.between?(0, values.length - 1) && col2.between?(0, values[0].length - 1)
    values[row1][col1] < values[row2][col2]
  else
    true
  end
end

def find_lowpoints(heightmap)
  [].tap do |lowpoints|
    (0...heightmap.length).each do |row|
      (0...heightmap[0].length).each do |col|
        next unless [[row, col - 1], [row - 1, col], [row, col + 1], [row + 1, col]].all? do |r, c|
          smaller_than(heightmap, row, col, r, c)
        end

        lowpoints << [row, col]
      end
    end
  end
end

def search_basin(basin, heightmap, row, col)
  return unless !basin.member?([row, col]) &&
                row.between?(0, heightmap.length - 1) &&
                col.between?(0, heightmap[0].length - 1) &&
                heightmap[row][col] != 9

  basin << [row, col]
  search_basin(basin, heightmap, row, col - 1)
  search_basin(basin, heightmap, row - 1, col)
  search_basin(basin, heightmap, row, col + 1)
  search_basin(basin, heightmap, row + 1, col)
  basin
end

heightmap = ARGF.each_line.map { |line| line.chomp.split('').map(&:to_i) }
lowpoints = find_lowpoints(heightmap)
top_basins = lowpoints.map do |row, col|
  search_basin(Set.new, heightmap, row, col)
end.map(&:length).sort.last(3).inject(&:*)
puts top_basins
