#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

maze, locations = load_input
distances = find_distances(maze, locations)
puts tsp(distances, '0', return_home: false)
