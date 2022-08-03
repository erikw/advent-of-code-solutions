#!/usr/bin/env ruby
# frozen_string_literal: true

#DISK_LEN = 20
DISK_LEN=272

state = ARGF.readline.chomp.chars.map(&:to_i)

until state.length >= DISK_LEN
  new = state.reverse.map { |d| d ^ 1 }.insert(0, 0)
  state.concat(new)
end
state = state[...DISK_LEN]

checksum = state
loop do
  checksum = checksum.each_slice(2).map { |a, b| ~(a ^ b) & 1 }
  break if checksum.length.odd?
end
puts checksum.join
