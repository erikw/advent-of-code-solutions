#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'scrambler'

# PW_INIT = 'decab'
PW_INIT = 'fbgdceah'

puts Scrambler.new(ARGF.readlines.map(&:chomp)).unscramble(PW_INIT)
