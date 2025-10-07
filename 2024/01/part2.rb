#!/usr/bin/env ruby
# frozen_string_literal: true

left, right = ARGF.each_line.map { |l| l.split.map(&:to_i) }.transpose
rcounts = right.tally.tap { |h| h.default = 0 }
sim_score = left.sum { |n| n * rcounts[n] }

puts sim_score
