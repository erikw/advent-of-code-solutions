#!/usr/bin/env ruby

require 'set'

DIRECTION_DELTA = {
  '^' => [0, -1],
  'v' => [0, 1],
  '<' => [-1, 0],
  '>' => [1, 0]
}

CURVES = {
  ['^', '/'] => '>',
  ['<', '/'] => 'v',
  ['>', '/'] => '^',
  ['v', '/'] => '<',
  ['>', '\\'] => 'v',
  ['^', '\\'] => '<',
  ['v', '\\'] => '>',
  ['<', '\\'] => '^'
}

TURNS = {
  ['^', 0] => '<',
  ['^', 1] => '^',
  ['^', 2] => '>',
  ['>', 0] => '^',
  ['>', 1] => '>',
  ['>', 2] => 'v',
  ['v', 0] => '>',
  ['v', 1] => 'v',
  ['v', 2] => '<',
  ['<', 0] => 'v',
  ['<', 1] => '<',
  ['<', 2] => '^'
}

def move_cart(map, carts, cart_coord)
  x_new, y_new = cart_coord.zip(DIRECTION_DELTA[carts[cart_coord][0]]).map { |a, b| a + b }
  coord_new = [x_new, y_new]

  dir_old, turns_old = carts.delete(cart_coord)
  crashed_coord = nil

  if carts.key?(coord_new)
    carts.delete(coord_new)
    crashed_coord = coord_new
  elsif ['-', '|'].include?(map[y_new][x_new])
    carts[coord_new] = [dir_old, turns_old]
  elsif ['/', '\\'].include?(map[y_new][x_new])
    dir_new = CURVES[[dir_old, map[y_new][x_new]]]
    carts[coord_new] = [dir_new, turns_old]
  else # '+'
    turns = (turns_old + 1) % 3
    dir_new = TURNS[[dir_old, turns]]
    carts[coord_new] = [dir_new, turns]
  end

  crashed_coord
end

def print_map(map, carts)
  map.each.with_index do |row, y|
    row.each_char.with_index do |char, x|
      if carts.key?([x, y])
        print carts[[x, y]][0]
      else
        print char
      end
    end
    print "\n"
  end
end

map = ARGF.each_line.map(&:chomp)
carts = {}
(0...map.length).each do |y|
  (0...map[0].length).each do |x|
    next unless ['^', 'v', '<', '>'].include?(map[y][x])

    cart = map[y][x]
    carts[[x, y]] = [cart, -1]
    map[y][x] = case cart
                when '^' then '|'
                when 'v' then '|'
                when '<' then '-'
                when '>' then '-'
                end
  end
end

until carts.length == 1
  crashed_coords = Set.new
  carts.keys.sort_by { |coord| coord.reverse }.each do |coord|
    crashed_coords << move_cart(map, carts, coord) unless crashed_coords.include?(coord)
  end
end

puts carts.to_a.first.first.join(',')
