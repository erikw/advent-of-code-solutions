#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

coords = []
loop do
  line = ARGF.readline.chomp
  break if line.empty?

  x, y = line.split(',').map(&:to_i)

  coords << [x, y]
end

x_max = -1
y_max = -1
ARGF.each_line do |line|
  axis, fold_coord = line.delete_prefix('fold along ').split('=')
  fold_coord = fold_coord.to_i

  coords.map! do |x, y|
    if axis == 'x' && x > fold_coord
      x = 2 * fold_coord - x
    elsif axis == 'y' && y > fold_coord
      y = 2 * fold_coord - y
    end
    [x, y]
  end
  if axis == 'x'
    x_max = fold_coord
  else
    y_max = fold_coord
  end
end

coordset = Set.new(coords)
(0..y_max).each do |y|
  (0..x_max).each do |x|
    #print coordset.member?([x, y]) ? '#' : '.'
    print coordset.member?([x, y]) ? '#' : ' '
  end
  puts
end
