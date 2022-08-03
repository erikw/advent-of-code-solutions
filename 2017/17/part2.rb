#!/usr/bin/env ruby
# frozen_string_literal: true

VALUES = 50_000_000

steps = ARGF.readline.to_i

i = 0
buf_length = 1
after0 = 0
(1...VALUES).each do |v|
  i = (i + steps) % buf_length + 1
  buf_length += 1
  after0 = v if i == 1  # value 0 always at index 0
end
puts after0
