#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

program = ARGF.readlines.map { |l| l.chomp.split }
computer = Computer.new
computer.execute(program)
puts computer.registers['a']
