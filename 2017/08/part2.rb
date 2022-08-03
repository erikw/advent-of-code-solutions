#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

program = ARGF.readlines.map(&:chomp)
puts Computer.new.execute(program).max_seen
