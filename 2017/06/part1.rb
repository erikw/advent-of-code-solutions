#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'lib'

banks = ARGF.readline.split.map(&:to_i)

seen = Set.new
cycles = 0

until seen.include?(banks.hash)
  seen << banks.hash
  realloc(banks)
  cycles += 1
end

puts cycles
