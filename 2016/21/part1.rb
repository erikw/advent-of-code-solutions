#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'scrambler'

# PW_INIT = 'abcde'
PW_INIT = 'abcdefgh'

puts Scrambler.new(ARGF.readlines.map(&:chomp)).scramble(PW_INIT)
