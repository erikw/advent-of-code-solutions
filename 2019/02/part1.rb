#!/usr/bin/env ruby

require_relative 'computer'

intcode = ARGF.readline.split(',').map(&:to_i)
intcode[IP_NOUN] = 12
intcode[IP_VERB] = 2
puts Computer.new.execute(intcode).memory[0]
