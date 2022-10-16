#!/usr/bin/env ruby
# frozen_string_literal: true

SUBJECT_NR = 7
DIV = 20_201_227

def bf_loops(pub_key)
  value = 1
  loops = 0
  until value == pub_key
    value *= SUBJECT_NR
    value %= DIV
    loops += 1
  end
  loops
end

card_pub, door_pub = ARGF.each_line.map(&:to_i)

card_loops = bf_loops(card_pub)
door_loops = bf_loops(door_pub)

enc_key = 1
door_loops.times do
  enc_key *= card_pub
  enc_key %= DIV
end

puts enc_key
