#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

# program = ARGF.readlines.map { |l| l.chomp.split }
# computer = Computer.new(a: 175)
# computer.execute(program)
# puts computer.registers['a']

# See translated.rb via notes.txt
# Need a number d in bin rep
# ..1010
# We know that d = a + 365 * 7
# (7 * 365).to_s(2) =
# 100111111011
# thus we look for minumum d being
# 101010101010
# "101010101010".to_i(2) = 2730
# a = 365 * 7 - d = 175
puts 175
