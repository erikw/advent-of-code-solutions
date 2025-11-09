#!/usr/bin/env ruby
# frozen_string_literal: true

def design_possible?(patterns, design, dstart = 0, memo = {})
  return 1 if dstart == design.length
  return memo[dstart] if memo.key?(dstart)

  memo[dstart] = ((dstart + 1)..design.length).sum do |dend|
    sub_design = design[dstart...dend]
    if patterns.include?(sub_design)
      design_possible?(patterns, design, dend, memo)
    else
      0
    end
  end
  memo[dstart]
end

in_patterns, in_designs = ARGF.read.split("\n\n")
patterns = in_patterns.split(', ').to_set
designs = in_designs.each_line(chomp: true).to_a

ways = designs.sum do |design|
  design_possible?(patterns, design)
end

puts ways
