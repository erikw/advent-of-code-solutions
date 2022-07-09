#!/usr/bin/env ruby

def valid(num)
  repeated = false
  increasing = true

  last = 10
  rep_cnt = 0
  until num == 0
    digit = num % 10

    if digit != last
      repeated = true if rep_cnt == 2
      rep_cnt = 0
    end
    rep_cnt += 1

    increasing = false if digit > last

    num /= 10
    last = digit
  end
  repeated = true if rep_cnt == 2

  repeated && increasing
end

lo, hi = ARGF.readline.chomp.split('-').map(&:to_i)
num_valid = (lo..hi).count { |pw| valid(pw) }
puts num_valid
