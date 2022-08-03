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

def digit_lens
  DIGIT_MAP.transform_values { |v| v.length }.sort_by { |_k, v| v }
end
# patterns, output = gets.split('|').map { |part| part.split }
count = 0
ARGF.each_line do |line|
  patterns, outputs = line.split('|').map { |part| part.split.map { |e| e.chars.sort.join } }

  # p patterns, output
  # pp digit_lens

  count += outputs.count { |output| [2, 4, 3, 7].include?(output.length) }
end
puts count
