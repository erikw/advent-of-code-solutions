#!/usr/bin/env ruby

require_relative 'computer'

program = ARGF.readlines.map(&:chomp)
puts Computer.new.execute(program).registers.values.max
