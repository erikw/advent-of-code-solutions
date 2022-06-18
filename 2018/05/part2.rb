#!/usr/bin/env ruby

require_relative 'lib'

polymer = ARGF.readline.chomp.chars
units = polymer.map(&:downcase).uniq

shortest = Float::INFINITY
units.each do |unit|
  polymer_fixed = polymer.reject { |p| [unit, unit.upcase].include? p }
  len = react(polymer_fixed).length
  shortest = [shortest, len].min
end
puts shortest
