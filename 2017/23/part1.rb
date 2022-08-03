#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

instructions = ARGF.readlines.map { |l| l.chomp.split }
computer = Computer.new
puts computer.execute(instructions).registers['muls']
