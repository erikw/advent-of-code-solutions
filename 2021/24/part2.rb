#!/usr/bin/env ruby

require_relative 'lib'

constraints = find_constraints(ARGF)
puts solve(constraints)[1]
