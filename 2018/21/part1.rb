#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

instructions = ARGF.each_line.map { |l| l.chomp.split }
puts Computer.new.execute(instructions, watch_line: 28, watch_action: :halt).registers[1]
