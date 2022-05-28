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

elf = Elf.new(0)
elf_first = elf
(1...nbr_elfs).each do |i|
  elf_new = Elf.new(i)
  elf.next = elf_new
  elf = elf_new
end
elf.next = elf_first

elf = elf_first

while elf.next != elf
  elf_next = elf.next
  elf.gifts += elf_next.gifts
  elf.next = elf_next.next
  elf = elf.next
end

puts elf.nbr + 1
