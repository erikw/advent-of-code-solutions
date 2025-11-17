#!/usr/bin/env ruby
# Optimized version of part1.rb. However memory still explodes.
# frozen_string_literal: true

require 'pqueue'

# KEYPADS = 2
KEYPADS = 25

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

def dir_path(neighbors, path)
  path.each_cons(2).map do |p1, p2|
    neighbors[p1][p2]
  end
end

# Recursive back-tracking of Dijkstra's algorithm's "prevs" output to find *all* shortests path from self to target.
def all_paths(prevs, start, current)
  return [[current]] if current == start
  return [] if prevs[current].empty?

  prevs[current].flat_map do |prev|
    all_paths(prevs, start, *prev).map { |p| p + [current] }
  end
end

# Modified Dijkstra to find all shortest paths (translated to directions).
# Note: need to look at all prev[[pos_end, *dir*]] and select the ones that led to the shortest path, not all paths entering pos_end are a shortest path!
def shortest_dirs(neighbors, start, goal, memo = {})
  key = [start, goal]
  return memo[key] if memo.key?(key)

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

  dirs = Set.new # TODO can to .to_set on enum below
  all_paths(prevs, start, goal).each do |p|
    dirs << dir_path(neighbors, p).join
  end

  memo[key] = dirs
end

def shortest_key_paths(keys, adj_list, memo = {})
  paths = Set['']

  [ACTION_KEY].concat(keys).each_cons(2) do |k1, k2|
    transitions = shortest_dirs(adj_list, k1, k2, memo)

    paths_next = Set.new

    paths.each do |prefix|
      transitions.each do |t|
        paths_next << (prefix + t + ACTION_KEY)
      end
    end

    paths = paths_next
    paths = paths_next.to_a.uniq.to_set
  end

  paths
end

door_codes = ARGF.each_line(chomp: true).map(&:chars)
memo = {}

complex_sum = door_codes.sum do |door_code|
  paths = shortest_key_paths(door_code, NUMERIC_PAD_ADJ)

  KEYPADS.times do |i|
    puts "At keypad #{i + 1}"
    # paths_next = []

    # paths.each do |p|
    #  paths_next << shortest_key_paths(p.chars, DIRECTIONAL_PAD_ADJ, memo)
    # end

    # lengths = paths_next.map { |s| s.first.length }
    # mind = lengths.min

    # paths = paths_next
    #        .select { |s| s.first.length == mind }
    #        .flat_map(&:to_a)
    #        .to_set

    paths_next = Set.new

    paths.each do |p|
      s = shortest_key_paths(p.chars, DIRECTIONAL_PAD_ADJ, memo)
      s.each { |x| paths_next << x }
    end

    # prune to shortest
    mind = paths_next.map(&:length).min
    paths = paths_next.select { |x| x.length == mind }
  end

  len = paths.first.length
  numpart = door_code.join.to_i
  len * numpart
end

puts complex_sum
