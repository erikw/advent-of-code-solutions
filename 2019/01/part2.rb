#!/usr/bin/env ruby
# frozen_string_literal: true

def fuel(mass)
  f = mass / 3 - 2
  f <= 0 ? 0 : f + fuel(f)
end

puts ARGF.each_line.map { |l| fuel(l.to_i) }.sum
