#!/usr/bin/env ruby
# frozen_string_literal: true

chars_code = 0
chars_mem = 0

ARGF.each_line.map(&:chomp).each do |string|
  chars_code += string.length
  strmem = string.gsub(/\\x[0-9a-f]{2}/i, 'x').gsub(/\\"/, '"').gsub(/\\\\/, '\\')
  chars_mem += strmem.length - 2
end

puts chars_code - chars_mem
