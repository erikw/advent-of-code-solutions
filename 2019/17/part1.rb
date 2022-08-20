#!/usr/bin/env ruby
# frozen_string_literal: true

require '../09/computer'

SYM_SCAFFOLD = '#'
SYM_OPEN = '.'
SYM_TUMBLING = 'X'

SYM_UP = '^'
SYM_DOWN = 'v'
SYM_LEFT = '<'
SYM_RIGHT = '>'

SYM_SCAFFOLD_ALL = [SYM_SCAFFOLD, SYM_UP, SYM_DOWN, SYM_LEFT, SYM_RIGHT]

def print_image(image)
  image.each do |row|
    puts row
  end
end

def intersection?(image, row, col)
  return false unless SYM_SCAFFOLD_ALL.include?(image[row][col])

  [[-1, 0], [1, 0], [0, -1], [0, 1]].all? do |dr, dc|
    rown = row + dr
    coln = col + dc
    rown.between?(0, image.length - 1) &&
      coln.between?(0, image[0].length - 1) &&
      SYM_SCAFFOLD_ALL.include?(image[rown][coln])
  end
end

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
comp_thr = Thread.new { computer.execute(intcode) }
comp_thr.join

image = []
image << computer.stdout.pop.chr until computer.stdout.empty?
image = image.join.split("\n")
# print_image(image)

alignparam_sum = 0
(0...image.length).each do |row|
  (0...image[0].length).each do |col|
    alignparam_sum += row * col if intersection?(image, row, col)
  end
end

puts alignparam_sum
