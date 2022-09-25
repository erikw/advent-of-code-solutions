#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

SUM = 2020

expenses = ARGF.each_line.map(&:to_i).to_set

expenses.each do |expense|
  complement = SUM - expense
  if expenses.include?(complement)
    puts expense * complement
    exit
  end
end
