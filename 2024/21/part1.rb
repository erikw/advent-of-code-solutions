#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

KEYPADS = 2

ACTION_KEY = 'A'

# Adjancy list for numereric keypad. keypad -> {keypad -> dir}
NUMERIC_PAD_ADJ = {
  '7' => { '8' => '>', '4' => 'v' },
  '8' => { '9' => '>', '5' => 'v', '7' => '<' },
  '9' => { '6' => 'v', '8' => '<' },
  '4' => { '7' => '^', '5' => '>', '1' => 'v' },
  '5' => { '8' => '^', '6' => '>', '2' => 'v', '4' => '<' },
  '6' => { '9' => '^', '3' => 'v', '5' => '<' },
  '1' => { '4' => '^', '2' => '>' },
  '2' => { '5' => '^', '3' => '>', '0' => 'v', '1' => '<' },
  '3' => { '6' => '^', 'A' => 'v', '2' => '<' },
  '0' => { '2' => '^', 'A' => '>' },
  'A' => { '3' => '^', '0' => '<' }
}.freeze

# Adjancy list for directional keypad. keypad -> {keypad -> dir}
DIRECTIONAL_PAD_ADJ = {
  '^' => { 'A' => '>', 'v' => 'v' },
  'A' => { '>' => 'v', '^' => '<' },
  '<' => { 'v' => '>' },
  'v' => { '^' => '^', '>' => '>', '<' => '<' },
  '>' => { 'A' => '^', 'v' => '<' }
}.freeze

# Recursive back-tracking of Dijkstra's algorithm's "prevs" output to find *all* shortests path from self to target.
def all_paths(prevs, start, current)
  return [[current]] if current == start
  return [] if prevs[current].empty?

  prevs[current].flat_map do |prev|
    all_paths(prevs, start, *prev).map { |p| p + [current] }
  end
end

# Modified to find all shortest paths.
# Note: need to look at all prev[[pos_end, *dir*]] and select the ones that led to the shortest path, not all paths entering pos_end are a shortest path!
def shortest_path_dijkstra(neighbors, start, goal)
  distances = Hash.new(Float::INFINITY)
  distances[start] = 0
  prevs = Hash.new { |h, k| h[k] = [] } # Save all previous on any best path
  pq = PQueue.new([{ node: start, dist: 0 }]) { |a, b| a[:dist] < b[:dist] }

  until pq.empty?
    node, dist = pq.pop.values_at(:node, :dist)
    next if dist > distances[node]

    neighbors[node].each_key do |neighbor|
      dist_alt = distances[node] + 1
      if dist_alt < distances[neighbor]
        distances[neighbor] = dist_alt
        prevs[neighbor] = [node] # Starting a new best path.
        pq << { node: neighbor, dist: dist_alt }
      elsif dist_alt == distances[neighbor]
        prevs[neighbor] << node
      end
    end

  end
  [distances[goal], all_paths(prevs, start, goal)]
end

def dir_path(neighbors, path)
  path.each_cons(2).map do |p1, p2|
    neighbors[p1][p2]
  end
end

def shortest_key_paths(keys, adj_list)
  paths = [[]]
  [ACTION_KEY].concat(keys).each_cons(2) do |key1, key2|
    key_paths = shortest_path_dijkstra(adj_list, key1, key2)[1]
    paths_next = []
    key_paths.each do |key_path|
      key_path_dir = dir_path(adj_list, key_path)
      key_path_dir << ACTION_KEY
      paths.each do |path|
        paths_next << path + key_path_dir
      end
    end
    paths = paths_next
  end
  paths
end

door_codes = ARGF.each_line(chomp: true).map(&:chars)

complex_sum = door_codes.sum do |door_code|
  paths = shortest_key_paths(door_code, NUMERIC_PAD_ADJ)

  # It's not enough to find *a* shortest path, but we need to try all select *all* the easiest one to type...
  KEYPADS.times do
    paths_next = paths.map do |path|
      shortest_key_paths(path, DIRECTIONAL_PAD_ADJ)
    end
    paths_next_mindist = paths_next.map { |paths| paths.first.size }.min
    paths = paths_next.select { |paths| paths.first.size == paths_next_mindist }.flatten(1)
  end

  len = paths[0].size
  numpart = door_code.join.to_i
  len * numpart
end

puts complex_sum
