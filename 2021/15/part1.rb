#!/usr/bin/env ruby
# frozen_string_literal: true
# Dijkstra naive implementation

require 'set'

def fetch_min_unvisited(distance, unvisited)
  row, col = unvisited.min_by do |row, col|
    distance[row][col]
  end
  unvisited.delete([row, col])
  [row, col]
end

def update_neighbour(risk, distance, row_cur, col_cur, row_n, col_n)
  if row_n.between?(0, risk.length - 1) && col_n.between?(0, risk[0].length - 1)
    dist_contend = distance[row_cur][col_cur] + risk[row_n][col_n]
    dist_now = distance[row_n][col_n]
    distance[row_n][col_n] = [dist_contend, dist_now].min
  end
end

risk = ARGF.each_line.map { |line| line.chomp.chars.map(&:to_i) }

distance = Array.new(risk.length)
unvisited = Set.new
(0...risk.length).each do |row|
  distance[row] = Array.new(risk[0].length)
  (0...risk[0].length).each do |col|
    distance[row][col] = Float::INFINITY
    unvisited << [row, col]
  end
end
distance[0][0] = 0

until unvisited.empty?
  row, col = fetch_min_unvisited(distance, unvisited)

  break if [row, col] == [risk.length - 1, risk[0].length - 1]

  update_neighbour(risk, distance, row, col, row, col - 1)
  update_neighbour(risk, distance, row, col, row - 1, col)
  update_neighbour(risk, distance, row, col, row, col + 1)
  update_neighbour(risk, distance, row, col, row + 1, col)
end

puts distance[risk.length - 1][risk[0].length - 1]
