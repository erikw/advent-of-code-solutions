#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'sfnumber'

max = ARGF.each_line.map(&:to_sfnumber).combination(2).map do |nbr1, nbr2|
  [(nbr1 + nbr2).magnitude, (nbr2 + nbr1).magnitude].max
end.max
puts max
