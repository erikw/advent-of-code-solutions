#!/usr/bin/env ruby
# frozen_string_literal: true

ITERATIONS = 100

NEIGHBOUR_DELTAS = [-1, 0, 1]

def update_neighbour(octopi, row, col)
  octopi[row][col] += 1 if row.between?(0, octopi.length - 1) &&
                           col.between?(0, octopi[0].length - 1) &&
                           octopi[row][col] != 0
end

def update_neighbours(octopi, row, col)
  NEIGHBOUR_DELTAS.each do |dr|
    NEIGHBOUR_DELTAS.each do |dc|
      next if dr == 0 && dc == 0

      update_neighbour(octopi, row + dr, col + dc)
    end
  end
end

octopi = ARGF.each_line.map do |line|
  line.chomp.chars.map(&:to_i)
end

flashes = 0
ITERATIONS.times do
  (0...octopi.length).each do |row|
    (0...octopi[0].length).each do |col|
      octopi[row][col] += 1
    end
  end

  loop do
    new_flashers = 0

    (0...octopi.length).each do |row|
      (0...octopi[0].length).each do |col|
        next unless octopi[row][col] > 9

        new_flashers += 1
        octopi[row][col] = 0
        update_neighbours(octopi, row, col)
      end
    end

    flashes += new_flashers
    break if new_flashers == 0
  end
end

puts flashes
