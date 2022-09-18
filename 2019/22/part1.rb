#!/usr/bin/env ruby
# frozen_string_literal: true

# NO_CARDS = 10
NO_CARDS = 10_007

SEARCH_CARD = 2019

def deal(deck)
  deck.reverse!
end

def cut(deck, cut)
  deck.rotate!(cut)
end

def deal_increment(deck, increment)
  new = Array.new(deck.length)
  i = 0
  j = 0
  deck.length.times do
    new[i % deck.length] = deck[j]
    i += increment
    j += 1
  end
  deck.replace(new)
end

deck = (0...NO_CARDS).to_a
ARGF.each_line do |line|
  case line.chomp
  when /deal into new stack/
    deal(deck)
  when /cut (-?\d+)/
    cut = Regexp.last_match(1).to_i
    cut(deck, cut)
  when /deal with increment (\d+)/
    inc = Regexp.last_match(1).to_i
    deal_increment(deck, inc)
  end
end

puts deck.index(SEARCH_CARD)
