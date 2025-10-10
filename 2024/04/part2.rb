#!/usr/bin/env ruby
# frozen_string_literal: true

TARGET = 'MAS'

DELTA_PAIRS = [
  [[-1, -1], [1, 1]],
  [[-1, 1], [1, -1]]
].freeze

def search(target, word_search, pos_middle, delta_pair)
  pos_sides = delta_pair.map { |dp| pos_middle.zip(dp).map { |a, b| a + b } }

  pos_sides.permutation.any? do |p1, p2|
    word_search[p1] == target[0] && word_search[p2] == target[2]
  end
end

start_poss = []
word_search = Hash.new('.')
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |char, col|
    pos = [row, col]
    start_poss << pos if char == TARGET[1]
    word_search[pos] = char
  end
end

occurences = start_poss.count do |start_pos|
  DELTA_PAIRS.all? do |delta_pair|
    search(TARGET, word_search, start_pos, delta_pair)
  end
end
puts occurences
