#!/usr/bin/env ruby

puts ARGF.each_line.map(&:to_i).sum
