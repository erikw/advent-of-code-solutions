#!/usr/bin/env ruby

checksum = ARGF.each_line.sum do |line|
  line.split.map(&:to_i).minmax.reverse.inject(&:-)
end
puts checksum
