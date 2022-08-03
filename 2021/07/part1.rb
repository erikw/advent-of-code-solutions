#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'array'

positions = gets.split(',').map(&:to_i)
median = positions.median
puts positions.map { |pos| (pos - median).abs }.sum.to_i
