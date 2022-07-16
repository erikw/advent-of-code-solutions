#!/usr/bin/env ruby

IMG_W = 25
IMG_H = 6

COLOR_TRANS = 2
PRINT_MAP = { 0 => ' ', 1 => '#' }

image = ARGF.readline.chomp.split('').map(&:to_i).each_slice(IMG_W * IMG_H).reverse_each.reduce do |img, layer|
  img.length.times do |i|
    img[i] = layer[i] unless layer[i] == COLOR_TRANS
  end
  img
end

image.map { |d| PRINT_MAP[d] }.each_slice(IMG_W) do |row|
  puts row.join
end
