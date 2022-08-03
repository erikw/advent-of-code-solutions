#!/usr/bin/env ruby
# frozen_string_literal: true

total_score = 0
score = 0
skip_next = false
in_garbage = false
ARGF.readline.chomp.each_char do |c|
  if skip_next
    skip_next = false
    next
  end

  if c == '!'
    skip_next = true
  elsif in_garbage
    in_garbage = false if c == '>'
  elsif c == '{'
    score += 1
    total_score += score
  elsif c == '}'
    score -= 1
  elsif c == '<'
    in_garbage = true
  end
end

puts total_score
