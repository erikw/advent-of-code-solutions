#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

NTH_NUMBER = 2020

nums_start = ARGF.readline.split(',').map(&:to_i)
puts nth_spoken(nums_start, NTH_NUMBER)
