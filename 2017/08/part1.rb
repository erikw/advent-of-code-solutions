#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

program = ARGF.readlines.map(&:chomp)
puts Computer.new.execute(program).registers.values.max
