#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def round_winner(deck1, deck2, cache)
  states1 = Set.new
  states2 = Set.new
  until deck1.empty? || deck2.empty?
    return  :p1 if states1.include?(deck1.hash) || states2.include?(deck2.hash)

    states1 << deck1.hash
    states2 << deck2.hash

    card1 = deck1.shift
    card2 = deck2.shift

    winner = if deck1.length >= card1 && deck2.length >= card2
               recursive_combat(deck1.take(card1), deck2.take(card2), cache)
             else
               card1 > card2 ? :p1 : :p2
             end

    if winner == :p1
      deck1 << card1 << card2
    else
      deck2 << card2 << card1
    end
  end

  deck1.empty? ? :p2 : :p1
end

def recursive_combat(deck1, deck2, cache = {})
  cache_key = (deck1 + deck2).hash
  cache[cache_key] ||= round_winner(deck1, deck2, cache)
  cache[cache_key]
end

def score(deck)
  deck.reverse.each_with_index.sum do |card, i|
    card * (i + 1)
  end
end

deck1, deck2 = ARGF.readlines('').map do |part|
  part.chomp.lines.drop(1).map(&:to_i)
end

winner = recursive_combat(deck1, deck2)
puts score(winner == :p1 ? deck1 : deck2)
