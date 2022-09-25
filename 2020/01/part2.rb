#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

SUM = 2020

expenses = ARGF.each_line.map(&:to_i).to_set

expenses.to_a.combination(2) do |exp1, exp2|
  exp3 = SUM - exp1 - exp2
  if expenses.include?(exp3)
    puts exp1 * exp2 * exp3
    exit
  end
end
