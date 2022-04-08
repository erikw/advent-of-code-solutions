#!/usr/bin/env ruby

require 'set'

replacements = Hash.new { |h, k| h[k] = [] }
while (rep = ARGF.readline.chomp.split(' => ')).length == 2
  replacements[rep[0]] << rep[1]
end
medicine = ARGF.readline.chomp

molecules = Set.new
replacements.each do |from, tos|
  (0..(medicine.length - from.length)).each do |i|
    next unless medicine[i, from.length] == from

    tos.each do |to|
      molecule = medicine.dup
      molecule[i, from.length] = to
      molecules << molecule
    end
  end
end

puts molecules.size
