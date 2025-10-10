#!/usr/bin/env ruby
# frozen_string_literal: true

TARGET = 'XMAS'

DELTAS = [
  [-1, 0],
  [-1, 1],
  [0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1]
].freeze

def search(target, word_search, pos, delta)
  target.each_char do |t|
    return false unless word_search[pos] == t

    pos = pos.zip(delta).map { |a, b| a + b }
  end
  true
end

start_poss = []
word_search = Hash.new('.')
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |char, col|
    pos = [row, col]
    start_poss << pos if char == TARGET[0]
    word_search[pos] = char
  end
end

occurences = start_poss.sum do |start_pos|
  DELTAS.count do |delta|
    search(TARGET, word_search, start_pos, delta)
  end
end
puts occurences
