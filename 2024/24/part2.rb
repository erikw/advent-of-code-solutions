#!/usr/bin/env ruby
# h/t https://www.reddit.com/r/adventofcode/comments/1hl698z/comment/m3kkp24/
# https://en.wikipedia.org/wiki/Adder_(electronics)#Ripple-carry_adder
# frozen_string_literal: true

def output_relevant(lines, c, op)
  lines.any? do |a, l_op, b, _arrow, _out|
    l_op == op && (a == c || b == c)
  end
end

lines = ARGF.read.split("\n\n")[1].each_line.map { |l| l.chomp.split }

results = lines.map do |a, op, b, _arrow, c|
  # Pick outputs from constant XORs. These are the “raw inputs” that flow through the network.
  cond1 = op == 'XOR' &&
          [a, b, c].all? { |d| !d.start_with?('x', 'y', 'z') }

  # Picks outputs from AND/XOR that feed into other gates. These are intermediate values.
  cond2 = op == 'AND' &&
          ![a, b].include?('x00') &&
          output_relevant(lines, c, 'XOR')
  cond3 = op == 'XOR' &&
          ![a, b].include?('x00') &&
          output_relevant(lines, c, 'OR')

  # Picks outputs that are intermediate z registers: These also propagate to the final z.
  cond4 = op != 'XOR' &&
          c.start_with?('z') &&
          c != 'z45'

  cond1 || cond2 || cond3 || cond4 ? c : nil
end.compact

puts results.sort.join(',')
