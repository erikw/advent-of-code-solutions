#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

REQUIRED_ATTRS = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

lines = ARGF.readlines.map(&:chomp)
valid = 0
passport = []

lines.each_with_index do |line, lineno|
  if line.empty? || lineno == (lines.length - 1)
    attributes = passport.join(' ').split(' ')
    present = attributes.map { |a| a.split(':') }.map(&:first).to_set
    valid += 1 if present >= REQUIRED_ATTRS
    passport.clear
  else
    passport << line
  end
end

puts valid
