#!/usr/bin/env ruby

require_relative 'game'

def nbr_elfs(units)
  units.count { |unit| unit.instance_of?(Elf) }
end

map_orig = read_input

attack = 4
loop do
  map = Marshal.load(Marshal.dump(map_orig))
  units = create_units(map, attack)
  elfs_before = nbr_elfs(units)
  begin
    outcome = play_game(map, units, elf_quit: true)
    puts outcome
    break
  rescue ElfDied
  end

  attack += 1
end
