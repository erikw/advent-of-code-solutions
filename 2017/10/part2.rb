#!/usr/bin/env ruby

require_relative 'knot_hash'

lengths = begin
  ARGF.readline.chomp.each_char.map(&:ord)
rescue EOFError
  []
end

puts KnotHash::KnotHasher.new.hash(lengths)
