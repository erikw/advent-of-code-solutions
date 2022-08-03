#!/usr/bin/env ruby
# frozen_string_literal: true

valid = ARGF.each_line.map(&:split).count do |passphrase|
  pass_tally = passphrase.map { |w| w.chars.tally }
  pass_tally.length == pass_tally.uniq.length
end
puts valid
