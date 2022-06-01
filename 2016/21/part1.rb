#!/usr/bin/env ruby

require_relative 'scrambler'

# PW_INIT = 'abcde'
PW_INIT = 'abcdefgh'

puts Scrambler.new(ARGF.readlines.map(&:chomp)).scramble(PW_INIT)
