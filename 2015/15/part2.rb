#!/usr/bin/env ruby
# frozen_string_literal: true

SPOONS_TOTAL = 100
CALORIES_TARGET = 500

def score(spoons, properties)
  (0...properties[0].length - 1).map do |p|
    term = (0...properties.length).sum do |i|
      spoons[i] * properties[i][p]
    end
    term < 0 ? 0 : term
  end.inject(&:*)
end

def calories(spoons, properties)
  (0...properties.length).sum do |i|
    spoons[i] * properties[i].last
  end
end

properties = ARGF.each_line.map { |l| l.split(/ |,/).select { |e| e =~ /\d+/ }.map(&:to_i) }

max_score = (0..SPOONS_TOTAL).to_a.combination(properties.length - 1).map do |indices|
  spoons = indices.each_cons(2).map do |i1, i2|
    i2 - i1
  end.prepend(indices[0]).append(SPOONS_TOTAL - indices.last)
  score(spoons, properties) * (calories(spoons, properties) == CALORIES_TARGET ? 1 : -1)
end.max
puts max_score
