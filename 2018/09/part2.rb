#!/usr/bin/env ruby

require_relative 'lib'

FACTOR = 100

players, marbles = ARGF.readline.scan(/\d+/).map(&:to_i)
scores = marble_game(players, marbles * FACTOR)
puts scores.max
