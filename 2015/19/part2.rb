#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

replacements = []
while (rep = ARGF.readline.chomp.split(' => ')).length == 2
  replacements << rep
end
medicine = ARGF.readline.chomp

replacements.sort_by! { |e| e[1].length }.reverse!

steps = 0
until medicine == 'e'
  replacements.each do |from, to|
    replaced = 0
    medicine.gsub!(to) do
      replaced += 1
      from
    end
    steps += replaced if replaced > 0
  end
end

puts steps
