#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

intcode = ARGF.readline.split(',').map(&:to_i)
computer = Computer.new
computer.stdin << 1
computer.execute(intcode)
puts computer.stdout.last
