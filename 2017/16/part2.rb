#!/usr/bin/env ruby

require_relative 'lib'

PROGRAMS = 16
DANCES = 1_000_000_000

moves = ARGF.readline.chomp.split(',')
programs = (0...PROGRAMS).map { |i| (i + 'a'.ord).chr }
programs_start = programs.dup

i = 0
while i < DANCES
  dance(programs, moves)
  i += 1
  i *= DANCES / i if programs == programs_start
end

puts programs.join
