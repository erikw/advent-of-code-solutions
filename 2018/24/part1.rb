#!/usr/bin/env ruby

require_relative 'lib'

groups = parse_input
puts battle(groups)[0]
