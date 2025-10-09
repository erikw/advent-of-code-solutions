#!/usr/bin/env ruby
# frozen_string_literal: true

DIFFS = [
  Set.new([1, 2, 3]),
  Set.new([-1, -2, -3])
].freeze

reports = ARGF.each_line.map { |l| l.split.map(&:to_i) }
safe = reports.count do |levels|
  diffs = levels.each_cons(2).map { |a, b| a - b }.to_set
  DIFFS.any? { |ds| diffs <= ds }
end
puts safe
