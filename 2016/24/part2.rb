#!/usr/bin/env ruby

require_relative 'lib'

maze, locations = load_input
distances = find_distances(maze, locations)
puts tsp(distances, '0')
