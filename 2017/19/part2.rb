#!/usr/bin/env ruby

require_relative 'lib'

diagram = ARGF.each_line.map(&:chomp)
puts traverse_routing(diagram)[1]
