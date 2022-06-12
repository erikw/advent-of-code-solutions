#!/usr/bin/env ruby

require_relative 'lib'

layers = []
ARGF.each_line do |line|
  layers << line.split(': ').map(&:to_i)
end

puts severeties(layers).sum
