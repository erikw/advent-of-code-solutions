#!/usr/bin/env ruby
# frozen_string_literal: true

DIFFS = [
  Set.new([1, 2, 3]),
  Set.new([-1, -2, -3])
].freeze

def safe_levels?(levels)
  diffs = levels.each_cons(2).map { |a, b| a - b }.to_set
  DIFFS.any? { |ds| diffs <= ds }
end

def variations_one_removed(enum)
  enum.each_index.map do |i|
    enum[0...i] + enum[i + 1..]
  end
end

reports = ARGF.each_line.map { |l| l.split.map(&:to_i) }
safe = reports.count do |levels|
  safe_levels?(levels) || variations_one_removed(levels).any?(&method(:safe_levels?))
end
puts safe
