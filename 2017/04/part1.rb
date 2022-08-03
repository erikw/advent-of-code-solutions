#!/usr/bin/env ruby
# frozen_string_literal: true

valid = ARGF.each_line.map(&:split).count do |passphrase|
  passphrase.length == passphrase.uniq.length
end
puts valid
