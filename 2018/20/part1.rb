#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

regex = ARGF.readline.chomp[1...-1]
parser = RegexMapParser.new(regex)
parser.parse
# print_map(parser.map)
dist, prev = dijkstra(parser.map)
puts dist.values.max
