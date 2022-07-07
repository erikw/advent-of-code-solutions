#!/usr/bin/env ruby
# A re-implementation of part1.rb, using Complex numbers as x,y coordinates.

# sym => dir
DIRECTION = {
  '^' => 0 - 1i,
  '>' => 1 + 0i,
  'v' => 0 + 1i,
  '<' => -1 + 0i
}

# [dir, curve] => dir_new
CURVES = {
  [0 - 1i, '/'] => 1 + 0i,
  [-1 + 0i, '/'] => 0 + 1i,
  [1 + 0i, '/'] => 0 - 1i,
  [0 + 1i, '/'] => -1 + 0i,
  [1 + 0i, '\\'] => 0 + 1i,
  [0 - 1i, '\\'] => -1 + 0i,
  [0 + 1i, '\\'] => +1 + 0i,
  [-1 + 0i, '\\'] => 0 - 1i
}

def move_cart(map, carts, cart_coord)
  coord_new = cart_coord + carts[cart_coord][0]

  dir_old, turns_old = carts.delete(cart_coord)
  crashed = false

  if carts.key?(coord_new)
    crashed = true
  elsif ['-', '|'].include?(map[coord_new.imag][coord_new.real])
    carts[coord_new] = [dir_old, turns_old]
  elsif ['/', '\\'].include?(map[coord_new.imag][coord_new.real])
    dir_new = CURVES[[dir_old, map[coord_new.imag][coord_new.real]]]
    if dir_new.nil?
    end
    carts[coord_new] = [dir_new, turns_old]
  else # '+'
    turns = (turns_old + 1) % 3
    dir_new = dir_old * (1i**turns) * -1i
    carts[coord_new] = [dir_new, turns]
  end

  [crashed, coord_new]
end

map = ARGF.each_line.map(&:chomp)
carts = {}  # [coord, rotation_mod]
(0...map.length).each do |y|
  (0...map[0].length).each do |x|
    next unless ['^', 'v', '<', '>'].include?(map[y][x])

    cart = map[y][x]
    carts[Complex(x, y)] = [DIRECTION[cart], -1]
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
    carts.keys.sort_by { |coord| [coord.imag, coord.real] }.each do |coord|
      crashed, coord_last = move_cart(map, carts, coord)
      throw :crashed if crashed
    end
  end
end

puts "#{coord_last.real},#{coord_last.imag}"
