#!/usr/bin/env ruby

nbr_elfs = ARGF.readline.to_i

gifts = Array.new(nbr_elfs, 1)

elf = 0
elf_next = nil
loop do
  # pp gifts
  elf = (elf + 1) % nbr_elfs while gifts[elf].zero?

  elf_next = (elf + 1) % nbr_elfs
  elf_next = (elf_next + 1) % nbr_elfs while gifts[elf_next].zero?
  gifts[elf] += gifts[elf_next]
  gifts[elf_next] = 0

  break if gifts[elf] == nbr_elfs

  elf = (elf_next + 1) % nbr_elfs
end

puts elf + 1
