#!/usr/bin/env ruby

VALUES = 2018

steps = ARGF.readline.to_i

buffer = [0]
i = 0
(1...VALUES).each do |v|
  i = (i + steps) % buffer.length + 1
  buffer.insert(i, v)
end
puts buffer[(i + 1) % buffer.length]
