#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

constraints = find_constraints(ARGF)
puts solve(constraints)[1]
