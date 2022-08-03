#!/usr/bin/env ruby
# frozen_string_literal: true

DIGIT_MAP = {
  '0' => 'abcefg',      # Len = 6
  '1' => 'cf',          # Len = 2 UNIQUE
  '2' => 'acdeg',       # Len = 5
  '3' => 'acdfg',       # Len = 5
  '4' => 'bcdf',        # Len = 4 UNIQUE
  '5' => 'abdfg',       # Len = 5
  '6' => 'abdefg',      # Len = 6
  '7' => 'acf',         # Len = 3 UNIQUE
  '8' => 'abcdefg',     # Len = 7 UNIQUE
  '9' => 'abcdfg'       # Len = 6
}

# Reference: https://www.reddit.com/r/adventofcode/comments/rbj87a/comment/hnpad75/?utm_source=share&utm_medium=web2x&context=3

count_map = DIGIT_MAP.map(&:last).join.chars.group_by(&:itself).map { |k, v| [k, v.length] }.to_h
countpattern2digit = DIGIT_MAP.map do |digit, pattern|
  pattern = pattern.each_char.map { |c| count_map[c] }.sort.join
  [pattern, digit]
end.to_h

sum = 0
puts(ARGF.each_line.map do |line|
  patterns, outputs = line.split('|').map { |part| part.split.map { |e| e.chars.sort.join } }

  count_map_pattern = patterns.join.chars.group_by(&:itself).map { |k, v| [k, v.length] }.to_h

  outputs.map do |output|
    countpattern = output.each_char.map { |c| count_map_pattern[c] }.sort.join
    countpattern2digit[countpattern]
  end.join.to_i
end.sum)
