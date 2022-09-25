#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

REQUIRED_ATTRS = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

def attribute_valid?(field, value)
  case field
  when 'byr'
    value.length == 4 && value.to_i.between?(1920, 2002)
  when 'iyr'
    value.length == 4 && value.to_i.between?(2010, 2020)
  when 'eyr'
    value.length == 4 && value.to_i.between?(2020, 2030)
  when 'hgt'
    if /^\d+cm$/ =~ value
      value.to_i.between?(150, 193)
    elsif /^\d+in$/ =~ value
      value.to_i.between?(59, 76)
    else
      false
    end
  when 'hcl'
    /^#[0-9a-f]{6}$/ =~ value
  when 'ecl'
    %w[amb blu brn gry grn hzl oth].include?(value)
  when 'pid'
    /^\d{9}$/ =~ value
  when 'cid'
    true
  else
    false
  end
end

def passport_valid?(passport_str)
  attributes = passport_str.split(' ').map { |a| a.split(':') }
  present = attributes.map(&:first).to_set
  present >= REQUIRED_ATTRS && attributes.all? { |a| attribute_valid?(*a) }
end

lines = ARGF.readlines.map(&:chomp)
valid = 0
passport = []

lines.each_with_index do |line, lineno|
  if line.empty? || lineno == (lines.length - 1)
    passport << line if lineno == (lines.length - 1)

    valid += 1 if passport_valid?(passport.join(' '))
    passport.clear
  else
    passport << line
  end
end

puts valid
