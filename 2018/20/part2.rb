#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

MIN_DOORS = 1000

regex = ARGF.readline.chomp[1...-1]
parser = RegexMapParser.new(regex)
parser.parse
dist, prev = dijkstra(parser.map)
puts dist.values.count { |d| d >= MIN_DOORS }
