#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'computer'

program = ARGF.readlines.map { |line| line.chomp.gsub(/,/, '').split }
puts Computer.new({ 'a' => 1, 'b' => 0 }).execute(program).registers['b']
