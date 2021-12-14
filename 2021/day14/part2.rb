#!/usr/bin/env ruby

ITERATIONS = 40

pair_counts = Hash.new(0) # C_1C_2 -> count
polymer = ARGF.readline.chomp
(0...polymer.length - 1).each do |i|
  pair = polymer[i] + polymer[i + 1]
  pair_counts[pair] += 1
end

productions = {}
ARGF.each_line do |line|
  pair, prod = line.chomp.split(' -> ')
  productions[pair] = prod
end

ITERATIONS.times do |_i|
  updates = Hash.new(0)
  pair_counts.each do |pair, count|
    pair1 = pair[0] + productions[pair]
    pair2 = productions[pair] + pair[1]
    updates[pair1] += count
    updates[pair2] += count
  end
  pair_counts = updates
end

res = pair_counts.flat_map do |pair, count|
  [[pair[0], count], [pair[1], count]]
end.group_by(&:first).values.map do |value|
  (value.map(&:last).sum / 2.0).round
end.minmax.sort.reverse.inject(&:-)
puts res
