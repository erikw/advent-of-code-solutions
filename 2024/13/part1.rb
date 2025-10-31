#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

TOKENS_BTN_A = 3
TOKENS_BTN_B = 1

def solve((a1, b1), (a2, b2), (c1, c2))
  a = Matrix[[a1, a2], [b1, b2]]
  b = Matrix[[c1], [c2]]

  x = a.lup.solve(b)

  if x.all? { |x| x.denominator == 1 }
    x.map(&:to_i).to_a.flatten
  else
    [0, 0]
  end
end

machines = ARGF.read.split("\n\n").map do |machine|
  machine.each_line.map do |line|
    line.scan(/\d+/).map(&:to_i)
  end
end

tokens = machines.sum do |btn_a, btn_b, prize|
  presses_a, presses_b = solve(btn_a, btn_b, prize)
  presses_a * TOKENS_BTN_A + presses_b * TOKENS_BTN_B
end

puts tokens
