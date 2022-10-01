#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

numbers = ARGF.each_line.map(&:to_i)
puts first_invalid(numbers)
