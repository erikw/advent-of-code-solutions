#!/usr/bin/env ruby

puts ARGF.each_line.map { |l| l.to_i / 3 - 2 }.sum
