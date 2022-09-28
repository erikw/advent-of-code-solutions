#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

answers = ARGF.each_line.map(&:chomp)

group = Set.new
total = 0
answers.each_with_index do |answer, i|
  last = i == (answers.length - 1)
  if answer.empty? || last
    group += Set.new(answer.chars) if last
    total += group.count
    group.clear
  else
    group += Set.new(answer.chars)
  end
end

puts total
