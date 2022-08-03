#!/usr/bin/env ruby
# frozen_string_literal: true

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}

score = ARGF.each_line.map do |line|
  stack = []
  broken_char = nil
  line.chomp.chars.each do |char|
    if PAIRS.keys.include?(char)
      stack.push(char)
    else
      opening = stack.pop
      if PAIRS[opening] != char
        broken_char = char
        break
      end
    end
  end
  broken_char
end.reject(&:nil?).map { |c| POINTS[c] }.sum

puts score
