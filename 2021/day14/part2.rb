#!/usr/bin/env ruby

ITERATIONS = 40

pair_counts = Hash.new(0) # "char1+char2" -> count
char_counts = Hash.new(0) # "char" ->count
polymer = ARGF.readline.chomp.chars
polymer.each_cons(2) { |a, b| pair_counts[a + b] += 1 }
polymer.each { |c| char_counts[c] += 1 }

prod = {}
ARGF.readline
ARGF.each_line do |line|
  prod.merge! [line.chomp.split(' -> ')].to_h
end

ITERATIONS.times do
  updates = Hash.new(0)
  pair_counts.each do |pair, count|
    updates[pair[0] + prod[pair]] += count
    updates[prod[pair] + pair[1]] += count
    char_counts[prod[pair]]       += count
  end
  pair_counts = updates
end

puts char_counts.values.minmax.sort.reverse.inject(&:-)
