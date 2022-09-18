#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Algorithm: parse instructions backwrads, just keep track on which position the searched card must have had.

NO_CARDS = 10
# NO_CARDS = 10_007

SEARCH_CARD = 2 # input1.0 -> card number 6 for
# SEARCH_CARD = 2020

def undeal(deck_size, pos)
  # deck.reverse!
  deck_size - 1 - pos
end

def uncut(deck_size, pos, cut)
  # deck.rotate!(cut)
  if cut >= 0
    if pos >= cut
      pos - cut
    else
      deck_size - 1 + pos
    end
  elsif pos <= (deck_size - 1 + cut)
    pos + cut.abs
  else
    pos - (deck_size + cut)
  end
end

# This algo is not correct as demonstrated in output2.1
def undeal_increment(deck_size, pos, increment)
  i = 0
  until pos == 0 || i == deck_size # || i = pos_orig
    i += 1
    # before = pos
    pos = (pos - increment) % deck_size
    # puts "#{i}: #{before} -> #{pos}"
  end
  i
end

pos = SEARCH_CARD
ARGF.each_line.reverse_each do |line|
  before = pos
  case line.chomp
  when /deal into new stack/
    pos = undeal(NO_CARDS, pos)
  when /cut (-?\d+)/
    cut = Regexp.last_match(1).to_i
    pos = uncut(NO_CARDS, pos, cut)
  when /deal with increment (\d+)/
    inc = Regexp.last_match(1).to_i
    pos = undeal_increment(NO_CARDS, pos, inc)
  end
  puts "#{line.chomp}: #{before} -> #{pos}"
end

puts pos
