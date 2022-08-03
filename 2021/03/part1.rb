#!/usr/bin/env ruby
# frozen_string_literal: true

def s1
  gamma = ARGF.each_line.map { |line| line.chomp.split('').map(&:to_i) }.transpose.map do |colchars|
    colchars.sum >= colchars.length / 2 ? '1' : '0'
  end.join.to_i(2)
  epsilon = (~gamma) & ~((~0) << gamma.to_s(2).length)

  puts gamma * epsilon
end

def s2
  gamma = ''
  epsilon = ''
  ARGF.each_line.map { |line| line.chomp.split('').map(&:to_i) }.transpose.each do |colchars|
    gamma += colchars.sum >= colchars.length / 2 ? '1' : '0'
    epsilon += ((gamma[-1].to_i + 1) % 2).to_s
  end
  puts gamma.to_i(2) * epsilon.to_i(2)
end

# s1
s2
