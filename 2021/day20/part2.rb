#!/usr/bin/env ruby

ALG_ITR = 50

def read_pixel(image_in, algorithm, itr, row, col)
  if row.between?(0, image_in.length - 1) && col.between?(0, image_in[0].length - 1)
    image_in[row][col]
  elsif algorithm[0] == '.'
    '.'
  else
    itr.even? ? '.' : '#'
  end
end

def determine_value(image_in, algorithm, itr, row, col)
  pixels = []
  [-1, 0, 1].each do |drow|
    [-1, 0, 1].each do |dcol|
      pixels << read_pixel(image_in, algorithm, itr, row + drow - 1, col + dcol - 1)
    end
  end
  alg_idx = pixels.map { |c| c == '.' ? 0 : 1 }.join('').to_i(2)
  algorithm[alg_idx]
end

def print_image(image)
  image.each do |row|
    puts row.join('')
  end
end

algorithm = ARGF.readline
ARGF.readline
image_in = ARGF.readlines.map(&:chomp).map(&:chars)

image_out = nil
ALG_ITR.times do |itr|
  image_out = Array.new(image_in.length + 2)
  (0...image_out.length).each do |row|
    image_out[row] = Array.new(image_in[0].length + 2)
    (0...image_out[row].length).each do |col|
      image_out[row][col] = determine_value(image_in, algorithm, itr, row, col)
    end
  end
  image_in = image_out
end

print_image(image_out)

puts image_out.map { |line| line.count('#') }.sum
