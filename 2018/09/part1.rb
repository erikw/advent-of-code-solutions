#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

players, marbles = ARGF.readline.scan(/\d+/).map(&:to_i)
scores = marble_game(players, marbles)
puts scores.max
