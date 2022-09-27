#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative 'lib'

ROWS_MISSING_FRONT = 5
ROWS_MISSING_BACK = 6

act_seats = ARGF.each_line.map { |l| calc_row_col(l.chomp) }
exp_seats = []
(ROWS_MISSING_FRONT...(ROWS - ROWS_MISSING_BACK)).each do |row|
  (0...COLS).each do |col|
    exp_seats << [row, col]
  end
end

my_seat = (Set.new(exp_seats) - Set.new(act_seats)).to_a.first
puts seat_id(*my_seat)
