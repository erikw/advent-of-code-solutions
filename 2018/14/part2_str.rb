#!/usr/bin/env ruby
# frozen_string_literal: true

FAST_FORWARD_ITERS = 20_000_000

input = ARGF.gets.chomp
recepies = '37'
elf_pos = [0, 1]

# until recepies.length >= 7 && recepies[-7..].include?(input)
FAST_FORWARD_ITERS.times do
  recepies += (recepies[elf_pos[0]].to_i + recepies[elf_pos[1]].to_i).to_s
  2.times do |i|
    elf_pos[i] = (elf_pos[i] + 1 + recepies[elf_pos[i]].to_i) % recepies.length
  end
end

puts recepies.index(input)
