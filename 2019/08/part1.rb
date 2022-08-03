#!/usr/bin/env ruby
# frozen_string_literal: true

IMG_W = 25
IMG_H = 6

ans = ARGF.readline.chomp.split('').map(&:to_i).each_slice(IMG_W * IMG_H).min_by do |layer|
  layer.count { |d| d.zero? }
end.tally.reject { |k, _v| k == 0 }.values.inject(&:*)
puts ans
