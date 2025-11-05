#!/usr/bin/env ruby
# Manually decoded ruby version on my `input` file.

a = 66_245_665
b = 0
c = 0
loop do
  # 2,4
  b = a % 8

  # 1,7
  b ^= 7

  # 7,5
  c = (a / 2**b).floor

  # 1,7
  b ^= 7

  # 4,6
  b ^= c

  # 0,3
  a = (a / 2**3).floor

  # 5,5
  print(b % 8)

  # 3,0
  break if a == 0
end
