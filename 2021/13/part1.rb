#!/usr/bin/env ruby

coords = []
loop do
  line = ARGF.readline.chomp
  break if line.empty?

  x, y = line.split(',').map(&:to_i)
  coords << [x, y]
end

count = 0
ARGF.each_line do |line|
  break if count == 1

  count += 1

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
end

puts coords.uniq.count
