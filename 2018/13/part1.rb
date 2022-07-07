#!/usr/bin/env ruby

DIRECTION_DELTA = {
  '^' => [0, -1],
  'v' => [0, 1],
  '<' => [-1, 0],
  '>' => [1, 0]
}

# [dir, curve] => dir_new
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

# [dir, rot_mod] => dir_new
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

  cart_old, turns_old = carts.delete(cart_coord)
  crashed = false

  if carts.key?(coord_new)
    crashed = true
  elsif ['-', '|'].include?(map[y_new][x_new])
    carts[coord_new] = [cart_old, turns_old]
  elsif ['/', '\\'].include?(map[y_new][x_new])
    dir_new = CURVES[[cart_old, map[y_new][x_new]]]
    carts[coord_new] = [dir_new, turns_old]
  else # '+'
    turns = (turns_old + 1) % 3
    dir_new = TURNS[[cart_old, turns]]
    carts[coord_new] = [dir_new, turns]
  end

  [crashed, coord_new]
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
carts = {}  # [cart_sym, rotation_mod]
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

coord_last = nil
catch(:crashed) do
  loop do
    carts.keys.sort_by { |coord| coord.reverse }.each do |coord|
      crashed, coord_last = move_cart(map, carts, coord)
      throw :crashed if crashed
    end
  end
end

puts coord_last.join(',')
