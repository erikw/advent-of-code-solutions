#!/usr/bin/env ruby
# frozen_string_literal: true

happiness = Hash.new { |h, k| h[k] = {} }
ARGF.each_line.map do |l|
  l.gsub(/would/, '').gsub(/happiness units by sitting next to/, '').gsub(/\./, '').split
end.each do |from, verb, units, to|
  happiness[from][to] = verb == 'gain' ? units.to_i : -1 * units.to_i
end

max = happiness.keys.permutation.map do |seating|
  seating.cycle.first(seating.length + 1).each_cons(2).map do |from, to|
    happiness[from][to] + happiness[to][from]
  end.sum
end.max
puts max
