#!/usr/bin/env ruby
# h/t https://www.reddit.com/r/adventofcode/comments/1hj2odw/comment/m33zr3f/
# frozen_string_literal: true

KEYPADS = 25
ACTION_KEY = 'A'

KEYPAD_NUMERIC = {
  '7' => Complex(0, 0),
  '8' => Complex(1, 0),
  '9' => Complex(2, 0),
  '4' => Complex(0, 1),
  '5' => Complex(1, 1),
  '6' => Complex(2, 1),
  '1' => Complex(0, 2),
  '2' => Complex(1, 2),
  '3' => Complex(2, 2),
  ' ' => Complex(0, 3),
  '0' => Complex(1, 3),
  'A' => Complex(2, 3)
}.freeze

KEYPAD_DIRECTIONAL = {
  ' ' => Complex(0, 0),
  '^' => Complex(1, 0),
  'A' => Complex(2, 0),
  '<' => Complex(0, 1),
  'v' => Complex(1, 1),
  '>' => Complex(2, 1)
}.freeze

def path(start, stop, path_cache)
  key = [start, stop]
  return path_cache[key] if path_cache.key?(key)

  pad = KEYPAD_NUMERIC.key?(start) && KEYPAD_NUMERIC.key?(stop) ? KEYPAD_NUMERIC : KEYPAD_DIRECTIONAL
  diff = pad[stop] - pad[start]

  dx = diff.real.to_i
  dy = diff.imag.to_i

  yy = (dy.negative? ? '^' * (-dy) : 'v' * dy)
  xx = (dx.negative? ? '<' * (-dx) : '>' * dx)

  # Avoid going over the space key.
  bad = pad[' '] - pad[start]
  prefer_yy_first =
    (dx.positive? || bad == dx) && (bad != dy * Complex(0, 1))

  result = (prefer_yy_first ? yy + xx : xx + yy) + ACTION_KEY
  path_cache[key] = result
end

def length(code, depth, path_cache, length_cache)
  key = [code, depth]
  return length_cache[key] if length_cache.key?(key)

  return code.length if depth.zero?

  s = 0
  code.chars.each_with_index do |c, i|
    prev = code[i - 1]
    s += length(path(prev, c, path_cache), depth - 1, path_cache, length_cache)
  end

  length_cache[key] = s
end

path_cache = {}
length_cache = {}

codes = ARGF.each_line(chomp: true)

complex_sum = codes.sum do |code|
  code[..-2].to_i * length(code, KEYPADS + 1, path_cache, length_cache)
end
puts complex_sum
