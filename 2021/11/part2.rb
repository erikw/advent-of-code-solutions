#!/usr/bin/env ruby
def update_neighbour(octopi, row, col)
  octopi[row][col] += 1 if row.between?(0, octopi.length - 1) &&
                           col.between?(0, octopi[0].length - 1) &&
                           octopi[row][col] != 0
end

def update_neighbours(octopi, row, col)
  update_neighbour(octopi, row, col - 1)
  update_neighbour(octopi, row - 1, col - 1)
  update_neighbour(octopi, row - 1, col)
  update_neighbour(octopi, row - 1, col + 1)
  update_neighbour(octopi, row, col + 1)
  update_neighbour(octopi, row + 1, col + 1)
  update_neighbour(octopi, row + 1, col)
  update_neighbour(octopi, row + 1, col - 1)
end

octopi = ARGF.each_line.map do |line|
  line.chomp.chars.map(&:to_i)
end

flashes = 0
steps = 0
loop do
  steps += 1
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
  break if octopi.map { |row| row.sum }.sum == 0
end

puts steps
