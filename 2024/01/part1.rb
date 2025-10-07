#!/usr/bin/env ruby
# frozen_string_literal: true

dist = ARGF.each_line.map do |l|
  l.split.map(&:to_i)
end.transpose.map(&:sort).transpose.sum { |a, b| (a - b).abs }

puts dist
