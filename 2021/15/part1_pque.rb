#!/usr/bin/env ruby
# Dijkstra priority queue implementation

require 'set'
require 'lazy_priority_queue'

def update_neighbour(risk, distance, unvisited, pq, row_cur, col_cur, row_n, col_n)
  if row_n.between?(0, risk.length - 1) && col_n.between?(0, risk[0].length - 1) && unvisited.include?([row_n, col_n])
    dist_contend = distance[row_cur][col_cur] + risk[row_n][col_n]
    dist_now = distance[row_n][col_n]
    distance[row_n][col_n] = [dist_contend, dist_now].min
    pq.decrease_key [row_n, col_n], distance[row_n][col_n]
  end
end

risk = ARGF.each_line.map { |line| line.chomp.chars.map(&:to_i) }

distance = Array.new(risk.length)
unvisited = Set.new
pq = MinPriorityQueue.new
(0...risk.length).each do |row|
  distance[row] = Array.new(risk[0].length)
  (0...risk[0].length).each do |col|
    distance[row][col] = row == 0 && col == 0 ? 0 : Float::INFINITY
    pq.push [row, col], distance[row][col]
    unvisited << [row, col]
  end
end
distance[0][0] = 0

until pq.empty?
  row, col = pq.pop
  unvisited.delete [row, col]

  break if [row, col] == [risk.length - 1, risk[0].length - 1]

  update_neighbour(risk, distance, unvisited, pq, row, col, row, col - 1)
  update_neighbour(risk, distance, unvisited, pq, row, col, row - 1, col)
  update_neighbour(risk, distance, unvisited, pq, row, col, row, col + 1)
  update_neighbour(risk, distance, unvisited, pq, row, col, row + 1, col)
end

puts distance[risk.length - 1][risk[0].length - 1]
