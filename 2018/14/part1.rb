#!/usr/bin/env ruby
# frozen_string_literal: true

RECEPIES_NEEDED = 10

nbr_recipies = ARGF.gets.to_i
recepies = [3, 7]
elf_pos = [0, 1]

until recepies.length >= nbr_recipies + RECEPIES_NEEDED
  sum = recepies[elf_pos[0]] + recepies[elf_pos[1]]
  recepies << sum / 10 if sum > 9
  recepies << sum % 10
  2.times do |i|
    elf_pos[i] = (elf_pos[i] + 1 + recepies[elf_pos[i]]) % recepies.length
  end
end

puts recepies[nbr_recipies, RECEPIES_NEEDED].join
