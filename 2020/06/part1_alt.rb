#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

group = Set.new
total = 0
ARGF.each_line.map(&:chomp).each do |answer|
  if answer.empty?
    total += group.count
    group.clear
  else
    group += Set.new(answer.chars)
  end
end
total += group.count

puts total
