#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

diagram = ARGF.each_line.map(&:chomp)
puts traverse_routing(diagram)[1]
