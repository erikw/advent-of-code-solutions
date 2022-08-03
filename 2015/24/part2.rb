#!/usr/bin/env ruby
# frozen_string_literal: true

# Props to https://www.reddit.com/r/adventofcode/comments/3y1s7f/comment/cy9sqq2/?utm_source=share&utm_medium=web2x&context=3
def min_quantum_packing(packages, groups)
  group_size = packages.sum / groups
  (1..packages.length).each do |len|
    qs = packages.combination(len).select { |c| c.sum == group_size }.map { |c| c.inject(&:*) }
    return qs.min unless qs.empty?
  end
end

packages = ARGF.readlines.map(&:to_i)
puts min_quantum_packing(packages, 4)
