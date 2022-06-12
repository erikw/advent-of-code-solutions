#!/usr/bin/env ruby

require_relative 'lib'

layers = []
ARGF.each_line do |line|
  layers << line.split(': ').map(&:to_i)
end

wait = 0
wait += 1 until severeties(layers, wait).length == 0
puts wait
