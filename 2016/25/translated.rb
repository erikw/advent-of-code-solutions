#!/usr/bin/env ruby
# frozen_string_literal: true

a = 175

d = a + 365 * 7
a = d
loop do
  b = a % 2
  a /= 2

  puts b

  a = d if a == 0
end
