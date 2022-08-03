#!/usr/bin/env ruby
# frozen_string_literal: true

chars_code = 0
chars_encode = 0

ARGF.each_line.map(&:chomp).each do |string|
  chars_code += string.length
  strencoded = string.gsub(/\\/, '\\\\\\').gsub(/"/, '\\"')
  chars_encode += strencoded.length + 2
end

puts chars_encode - chars_code
