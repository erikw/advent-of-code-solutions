#!/usr/bin/env ruby
# inpu1 is what this program should produced when fed with input input0.

DEST_MAP_FILE = 'input_full_map'
def create_tile(tile1, _nbr)
  Array.new(tile1.length).tap do |tile|
    (0...tile1.length).each do |row|
      tile[row] = Array.new(tile1[0].length)
      (0...tile1[0].length).each do |col|
        value = (tile1[row][col] + 1) % 10
        value = 1 if value == 0
        tile[row][col] = value
      end
    end
  end
end

def print_map(full_map)
  full_map.each do |row|
    row.each do |e|
      print e
    end
    print "\n"
  end
end

def write_map(full_map, dest_file)
  File.open(dest_file, 'w') do |file|
    full_map.each do |row|
      row.each do |e|
        file.write e
      end
      file.write "\n"
    end
  end
end

def insert_tile(full_map, tile, start_row, start_col)
  (0...tile.length).each do |row|
    (0..tile[0].length).each do |col|
      full_map[start_row + row][start_col + col] = tile[row][col]
    end
  end
end

tiles = [ARGF.each_line.map { |line| line.chomp.chars.map(&:to_i) }]
(1..8).each do |i|
  tiles << create_tile(tiles[i - 1], i)
end

full_map = Array.new(tiles[0].length * 5)
full_map.map! { |_row| Array.new(tiles[0].length * 5) }

# Tile pattern
# 1 2 3 4 5
# 2 3 4 5 6
# 3 4 5 6 7
# 4 5 6 7 8
# 5 6 7 8 9
(0...5).each do |row|
  insert_tile(full_map, tiles[row], tiles[0].length * row, tiles[0].length * 0)
  insert_tile(full_map, tiles[row + 1], tiles[0].length * row, tiles[0].length * 1)
  insert_tile(full_map, tiles[row + 2], tiles[0].length * row, tiles[0].length * 2)
  insert_tile(full_map, tiles[row + 3], tiles[0].length * row, tiles[0].length * 3)
  insert_tile(full_map, tiles[row + 4], tiles[0].length * row, tiles[0].length * 4)
end

# print_map(full_map)
write_map(full_map, DEST_MAP_FILE)
puts "Wrote: #{DEST_MAP_FILE}"
puts 'Feed this to part1.rb to solve part 2 of puzzle.'
