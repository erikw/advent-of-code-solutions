#!/usr/bin/env ruby
# frozen_string_literal: true

deck1, deck2 = ARGF.readlines('').map do |part|
  part.chomp.lines.drop(1).map(&:to_i)
end

until deck1.empty? || deck2.empty?
  card1 = deck1.shift
  card2 = deck2.shift
  if card1 > card2
    deck1 << card1 << card2
  else
    deck2 << card2 << card1
  end
end

deck_winner = deck1.empty? ? deck2 : deck1

score = deck_winner.reverse.each_with_index.sum do |card, i|
  card * (i + 1)
end
puts score
