#!/usr/bin/env ruby
# frozen_string_literal: true

def valid(num)
  repeated = false
  increasing = true

  last = 10
  until num == 0
    digit = num % 10

    repeated = true if digit == last
    increasing = false if digit > last

    num /= 10
    last = digit
  end
  repeated && increasing
end

lo, hi = ARGF.readline.chomp.split('-').map(&:to_i)
num_valid = (lo..hi).count { |pw| valid(pw) }
puts num_valid
