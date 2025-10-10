#!/usr/bin/env ruby
# frozen_string_literal: true

PATTERN_MUL = /mul\(\d{1,3},\d{1,3}\)/
PATTERN_ENABLERS = /do(?:n't)?\(\)/

PATTERN_INSTR = /(?:#{PATTERN_MUL})|(?:#{PATTERN_ENABLERS})/

instructions = ARGF.each_line.map do |l|
  l.scan(PATTERN_INSTR)
end.flatten

enabled = true

# mul_sum = instructions.map do |instr|
#  case instr
#  when /mul/
#    enabled ? instr.scan(/\d+/).map(&:to_i).reduce(&:*) : nil
#  when /do\(\)/
#    enabled = true
#    nil
#  when /don't\(\)/
#    enabled = false
#    nil
#  end
# end.compact.sum

mul_sum = 0
instructions.each do |instr|
  if instr =~ /mul/ && enabled
    mul_sum += instr.scan(/\d+/).map(&:to_i).reduce(&:*)
  elsif instr =~ /do\(\)/
    enabled = true
  elsif instr =~ /don't\(\)/
    enabled = false
  end
end

puts mul_sum
