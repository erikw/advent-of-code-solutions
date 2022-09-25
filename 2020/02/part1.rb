#!/usr/bin/env ruby
# frozen_string_literal: true

INPUT_PATTERN = /(?<lo>\d+)-(?<hi>\d+) (?<char>\w)/

valid = ARGF.each_line.count do |line|
  rule, password = line.chomp.split(': ')
  m = INPUT_PATTERN.match(rule)
  password.count(m[:char]).between?(m[:lo].to_i, m[:hi].to_i)
end
puts valid
