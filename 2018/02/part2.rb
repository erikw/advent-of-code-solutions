#!/usr/bin/env ruby
# frozen_string_literal: true

a, b = ARGF.each_line.map(&:chomp).map(&:chars).combination(2).select do |id1, id2|
  id1.zip(id2).count { |c1, c2| c1 != c2 } == 1
end.first
puts a.zip(b).select { |c1, c2| c1 == c2 }.map(&:first).join
