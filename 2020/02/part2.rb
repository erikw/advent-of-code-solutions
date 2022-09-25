#!/usr/bin/env ruby
# frozen_string_literal: true

INPUT_PATTERN = /(?<lo>\d+)-(?<hi>\d+) (?<char>\w)/

valid = ARGF.each_line.count do |line|
  rule, password = line.chomp.split(': ')
  m = INPUT_PATTERN.match(rule)
  present1 = password[m[:lo].to_i - 1] == m[:char]
  present2 = password[m[:hi].to_i - 1] == m[:char]
  present1 ^ present2
end
puts valid
