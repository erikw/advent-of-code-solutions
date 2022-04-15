#!/usr/bin/env ruby

require_relative 'computer'

program = ARGF.readlines.map { |line| line.chomp.gsub(/,/, '').split }
puts Computer.new.execute(program).registers['b']
