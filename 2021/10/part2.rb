#!/usr/bin/env ruby
# frozen_string_literal: true

class Array
  def median
    sorted = sort
    if length.even?
      (sorted[length / 2 - 1] + sorted[length / 2]) / 2.0
    else
      sorted[length / 2]
    end
  end
end

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

score = ARGF.each_line.map do |line|
  stack = []
  broken = false
  score = 0
  line.chomp.chars.each do |char|
    if PAIRS.keys.include?(char)
      stack.push(char)
    else
      opening = stack.pop
      if PAIRS[opening] != char
        broken = true
        break
      end
    end
  end
  unless broken
    stack.reverse_each do |open_char|
      score = score * 5 + POINTS[PAIRS[open_char]]
    end
  end
  score
end.reject { |s| s == 0 }.median

puts score
