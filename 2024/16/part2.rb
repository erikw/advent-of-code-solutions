#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

SCORE_STEP = 1
SCORE_ROTATE = 1000

SYM_START = 'S'
SYM_END = 'E'
SYM_WALL = '#'
SYM_GROUND = '.'
SYM_PATH = 'O'

DIR_NORTH = Complex(-1, 0)
DIR_EAST = Complex(0, 1)
DIR_SOUTH = Complex(1, 0)
DIR_WEST = Complex(0, -1)

NEIGHBOR_DELTAS = [
  DIR_NORTH,
  DIR_EAST,
  DIR_SOUTH,
  DIR_WEST
].freeze

DIR2SYM = {
  DIR_NORTH => '^',
  DIR_EAST => '>',
  DIR_SOUTH => 'v',
  DIR_WEST => '<'
}.freeze

def print_map(map, pos_start, pos_end, paths = {})
  pathdir_by_pos = paths.flatten(1).to_h
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |row|
    (ymin..ymax).each do |col|
      pos = Complex(row, col)
      if pos == pos_start
        print(SYM_START)
      elsif pos == pos_end
        print(SYM_END)
      elsif pathdir_by_pos.include?(pos)
        dir = pathdir_by_pos[pos]
        print(DIR2SYM[dir])
      else
        print(map[pos])
      end
    end
    puts
  end
end

def neighbour_positions(map, pos)
  NEIGHBOR_DELTAS.map { |d| [pos + d, d] }.select { |p, _d| map[p] == SYM_GROUND }
end

def turn_cost(pos_from, dir_from, dir_to)
  dist = distances[[pos_from, dir_from]] + SCORE_STEP
  if dir_to == dir_from
    # nop
  elsif dir_to * -1 == dir_from
    dist += SCORE_ROTATE * 2
  else
    dist += SCORE_ROTATE
  end
end

def turn_cost(dir_from, dir_to)
  return 0 if dir_to == dir_from
  return SCORE_ROTATE * 2 if dir_to == -dir_from

  SCORE_ROTATE
end

# Modified to find all shortest paths.
# Note: need to look att all prev[[pos_end, *dir*]] and select the ones that led to the shortest path, not all paths entering pos_end are a shortest path!
def shortest_path_dijkstra(map, pos_start, dir_start, pos_end)
  node_start = [pos_start, dir_start]
  distances = Hash.new(Float::INFINITY)
  distances[node_start] = 0
  prevs = Hash.new { |h, k| h[k] = [] } # Save all previous on any best path
  pq = PQueue.new([{ node: node_start, dist: 0 }]) { |a, b| a[:dist] < b[:dist] }

  until pq.empty?
    node, dist = pq.pop.values_at(:node, :dist)
    pos, dir = node
    next if dist > distances[node]

    neighbour_positions(map, pos).each do |node_n|
      _pos_n, dir_n = node_n
      dist_alt = distances[node] + SCORE_STEP + turn_cost(dir, dir_n)

      if dist_alt < distances[node_n]
        distances[node_n] = dist_alt
        prevs[node_n] = [[pos, dir]] # Starting a new best path.
        pq << { node: node_n, dist: dist_alt }
      elsif dist_alt == distances[node_n]
        prevs[node_n] << [pos, dir]
      end
    end

  end
  [distances, prevs]
end

# Recursive back-tracking of Dijkstra's algorithm's "prevs" output to find *all* shortests path from self to target.
def all_paths(prevs, pos_start, pos_current, dir_current)
  node = [pos_current, dir_current]
  return [[node]] if pos_current == pos_start
  return [] if prevs[node].empty?

  prevs[node].flat_map do |prev|
    all_paths(prevs, pos_start, *prev).map { |p| p + [node] }
  end
end

pos_start = nil
dir_start = DIR_EAST
pos_end = nil
map = {}
ARGF.each_line(chomp: true).with_index do |line, row|
  line.each_char.with_index do |sym, col|
    pos = Complex(row, col)
    if sym == SYM_START
      pos_start = pos
      map[pos] = SYM_GROUND
    elsif sym == SYM_END
      pos_end = pos
      map[pos] = SYM_GROUND
    else
      map[pos] = sym
    end
  end
end

dists, prevs = shortest_path_dijkstra(map, pos_start, dir_start, pos_end)

# Find all directions that reach the end with the minimal distance
dist_min = NEIGHBOR_DELTAS.map { |d| dists[[pos_end, d]] }.min
dir_ends = NEIGHBOR_DELTAS.select { |d| dists[[pos_end, d]] == dist_min }

paths = []
dir_ends.each do |dir_end|
  paths += all_paths(prevs, pos_start, pos_end, dir_end)
end

# print_map(map, pos_start, pos_end, paths)

best_path_tiles = paths.flatten(1).map(&:first).uniq.size
puts best_path_tiles
