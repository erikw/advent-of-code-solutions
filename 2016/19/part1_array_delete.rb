#!/usr/bin/env ruby
# frozen_string_literal: true

nbr_elfs = ARGF.readline.to_i

gifts = Array.new(nbr_elfs) { |i| [i, 1] }

elf = 0
loop do
  # pp gifts
  puts gifts.length
  elf_next = (elf + 1) % gifts.length

  # puts "elf (#{elf}): #{gifts[elf]}"
  # puts "elf_next (#{elf_next}): #{gifts[elf_next]}"

  gifts[elf][1] += gifts[elf_next][1]
  gifts.delete_at(elf_next)
  elf -= 1 if elf_next < elf

  break if gifts[elf][1] == nbr_elfs

  elf = (elf + 1) % gifts.length
end

puts gifts[elf][0] + 1
