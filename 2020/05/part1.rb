#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

puts ARGF.each_line.map { |l| seat_id(*calc_row_col(l.chomp)) }.max
