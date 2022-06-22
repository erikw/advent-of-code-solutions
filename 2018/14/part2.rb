#!/usr/bin/env ruby

SKIP_ITERATIONS = 20_000_000

input = ARGF.gets.to_i
input_len = input.to_s.length
input_digits = input.to_s.chars.map(&:to_i)
recepies = [3, 7]
elf_pos = [0, 1]

# Looping on condition like:
# until recepies.length >= input_len && (recepies[-input_len..] == input_digits || recepies[-input_len - 1..] == input_digits)
# takes forever. Instead: do enough iterations then look for the answer.
# Also lesson learned: goes a lot faster working on int array than string in Ruby, see part2_str.rb
SKIP_ITERATIONS.times do
  sum = recepies[elf_pos[0]] + recepies[elf_pos[1]]
  recepies << sum / 10 if sum > 9
  recepies << sum % 10
  2.times do |i|
    elf_pos[i] = (elf_pos[i] + 1 + recepies[elf_pos[i]]) % recepies.length
  end
end

puts recepies.map(&:to_s).join.index(input.to_s)
