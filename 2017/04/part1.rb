#!/usr/bin/env ruby

valid = ARGF.each_line.map(&:split).count do |passphrase|
  passphrase.length == passphrase.uniq.length
end
puts valid
