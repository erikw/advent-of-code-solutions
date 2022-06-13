#!/usr/bin/env ruby

require_relative 'lib'

# PROGRAMS = 5
PROGRAMS = 16

moves = ARGF.readline.chomp.split(',')
programs = (0...PROGRAMS).map { |i| (i + 'a'.ord).chr }
dance(programs, moves)
puts programs.join
