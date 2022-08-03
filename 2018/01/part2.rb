#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

seen = Set.new
ARGF.each_line.map(&:to_i).cycle.inject do |freq, df|
  if seen.include?(freq)
    puts freq
    break
  end
  seen << freq
  freq + df
end
