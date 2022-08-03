#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'scrambler'

# PW_SCRAMBLED_INIT = 'decab'
PW_SCRAMBLED_INIT = 'fbgdceah'

scrambler = Scrambler.new(ARGF.readlines.map(&:chomp))
PW_SCRAMBLED_INIT.chars.permutation do |password|
  if scrambler.scramble(password.join) == PW_SCRAMBLED_INIT
    puts password.join
    exit
  end
end
