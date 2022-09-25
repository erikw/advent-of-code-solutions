#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

SLOPES = [

  1 + 1i,
  1 + 3i,
  1 + 5i,
  1 + 7i,
  2 + 1i
]

map = read_input
hits_product = SLOPES.map { |s| trees_hit(map, s) }.inject(&:*)
puts hits_product
