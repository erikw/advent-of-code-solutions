#!/usr/bin/env ruby
# frozen_string_literal: true

IMG_W = 25
IMG_H = 6

COLOR_TRANS = 2
PRINT_MAP = { 0 => ' ', 1 => '#' }

layers = ARGF.readline.chomp.split('').map(&:to_i).each_slice(IMG_W * IMG_H).to_a

image = layers.last
layers[0...-1].reverse.each do |layer|
  layer.each_with_index do |digit, i|
    image[i] = digit unless digit == COLOR_TRANS
  end
end

image.each_slice(IMG_W) do |row|
  puts row.map { |d| PRINT_MAP[d] }.join
end
