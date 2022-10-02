#!/usr/bin/env ruby
# frozen_string_literal: true

mask_1 = nil
mask_0 = nil
mem = Hash.new(0)

ARGF.each_line do |line|
  lhs, rhs = line.chomp.split(' = ')
  if lhs == 'mask'
    mask_1 = rhs.each_char.map { |c| c == '1' ? '1' : '0' }.join.to_i(2)
    mask_0 = rhs.each_char.map { |c| c == '0' ? '0' : '1' }.join.to_i(2)
  else
    addr = lhs.scan(/\d+/).first.to_i
    val = (rhs.to_i | mask_1) & mask_0
    mem[addr] = val
  end
end

puts mem.values.sum
