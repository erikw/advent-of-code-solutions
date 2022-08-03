#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'knot_hash'

# kn = KnotHash::KnotHash.new(5)
kn = KnotHash::KnotHasher.new

lengths = ARGF.readline.split(',').map(&:to_i)
puts kn.simple_hash(lengths)
