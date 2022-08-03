#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'lib'

banks = ARGF.readline.split.map(&:to_i)

seen_at = {}
cycles = 0

until seen_at.key?(banks.hash)
  seen_at[banks.hash] = cycles
  realloc(banks)
  cycles += 1
end

puts cycles - seen_at[banks.hash]
