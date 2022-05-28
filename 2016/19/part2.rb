#!/usr/bin/env ruby

class Elf
  attr_reader :nbr
  attr_accessor :gifts, :next

  def initialize(nbr)
    @nbr = nbr
    @gifts = 1
    @next = nil
  end
end

nbr_elfs = ARGF.readline.to_i

# Let's create a ring of elfs!
elf_first = Elf.new(1)
elf = elf_first
(2..nbr_elfs).each do |i|
  elf_new = Elf.new(i)
  elf.next = elf_new
  elf = elf_new
end
elf.next = elf_first

elf = elf_first
elf_steal_before = elf  # Points to the elf before the one to steal from next time.
(nbr_elfs / 2 - 1).times do
  elf_steal_before = elf_steal_before.next
end

while elf.next != elf
  elf.gifts += elf_steal_before.next.gifts

  elf_steal_before.next = elf_steal_before.next.next
  nbr_elfs -= 1

  elf = elf.next
  elf_steal_before = elf_steal_before.next if nbr_elfs.even?
end

puts elf.nbr
