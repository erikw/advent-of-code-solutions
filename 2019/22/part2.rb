#!/usr/bin/env ruby
# frozen_string_literal: true

# Hats off to https://www.reddit.com/r/adventofcode/comments/ee0rqi/comment/fbnifwk/

NO_CARDS = 119_315_717_514_047
NO_SHUFFLES = 101_741_582_076_661
SEARCH_CARD = 2020

def undeal(deck_size, pos)
  deck_size - 1 - pos
end

def uncut(deck_size, pos, cut)
  (pos + cut + deck_size) % deck_size
end

def egcd(a, b)
  return [b, 0, 1] if a == 0

  g, y, x = egcd(b % a, a)
  [g, x - (b / a) * y, y]
end

# Ref: https://stackoverflow.com/a/9758173/265508
def modinv(a, m)
  g, x, y = egcd(a, m)
  raise 'modular inverse does not exist' unless g == 1

  x % m
end

def undeal_increment(deck_size, pos, increment)
  modinv(increment, deck_size) * pos % deck_size
end

def backtrack_pos(shuffles, search_card)
  pos = search_card
  shuffles.reverse_each do |line|
    case line
    when /deal into new stack/
      pos = undeal(NO_CARDS, pos)
    when /cut (-?\d+)/
      cut = Regexp.last_match(1).to_i
      pos = uncut(NO_CARDS, pos, cut)
    when /deal with increment (\d+)/
      inc = Regexp.last_match(1).to_i
      pos = undeal_increment(NO_CARDS, pos, inc)
    end
  end
  pos
end

shuffles = ARGF.each_line.map(&:chomp)

x = SEARCH_CARD
y = backtrack_pos(shuffles, x)
z = backtrack_pos(shuffles, y)
a = (y - z) * modinv(x - y + NO_CARDS, NO_CARDS) % NO_CARDS
b = (y - a * x) % NO_CARDS

pos = (a.pow(NO_SHUFFLES, NO_CARDS) * x + (a.pow(NO_SHUFFLES, NO_CARDS) - 1) * modinv(a - 1, NO_CARDS) * b) % NO_CARDS
puts pos
