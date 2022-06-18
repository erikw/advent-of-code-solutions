#!/usr/bin/env ruby

require_relative 'lib'

polymer = ARGF.readline.chomp.chars
puts react(polymer).length
