#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

group = nil
total = 0
ARGF.each_line.map(&:chomp).each do |answer|
  if answer.empty?
    total += group.count
    group = nil
  else
    chars = Set.new(answer.chars)
    group = group.nil? ? chars : group & chars
  end
end
total += group.count

puts total
