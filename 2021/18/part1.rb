#!/usr/bin/env ruby

require_relative 'sfnumber'

lhs = ARGF.readline.to_sfnumber
ARGF.each_line.map(&:to_sfnumber).each do |rhs|
  lhs += rhs
end
puts lhs.magnitude
