#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

SCORE_STEP = 1
SCORE_ROTATE = 1000

SYM_START = 'S'
SYM_END = 'E'
SYM_WALL = '#'
SYM_GROUND = '.'

DIR_NORTH = Complex(-1, 0)
DIR_EAST = Complex(0, 1)
DIR_SOUTH = Complex(1, 0)
DIR_WEST = Complex(0, -1)

NEIGHBOR_DELTAS = [
  DIR_NORTH,
  DIR_EAST,
  DIR_SOUTH,
  DIR_WEST
]

def print_map(map)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |row|
    (ymin..ymax).each do |col|
      pos = Complex(row, col)
      print(map[pos])
    end
    puts
  end
end

def neighbour_positions(map, pos)
  NEIGHBOR_DELTAS.map { |d| [pos + d, d] }.select { |p, d| map[p] == SYM_GROUND }
end

def shortest_path_dijkstra(map, pos_start, dir_start, pos_end)
  node_start = [pos_start, dir_start]
  distances = Hash.new(Float::INFINITY)
  distances[node_start] = 0
  prev = {}
  pq = PQueue.new([{ node: node_start, dist: 0 }]) { |a, b| a[:dist] < b[:dist] }

  until pq.empty?
    node, dist = pq.pop.values_at(:node, :dist)
    pos, dir = node
    next if dist > distances[node]

    return distances[node] if pos == pos_end

    neighbour_positions(map, pos).each do |node_n|
      pos_n, dir_n = node_n
      dist_alt = distances[[pos, dir]] + SCORE_STEP
      if dir_n == dir
        # nop
      elsif dir_n * -1 == dir
        dist_alt += SCORE_ROTATE * 2
      else
        dist_alt += SCORE_ROTATE
      end

      next unless dist_alt < distances[node_n]

      distances[node_n] = dist_alt
      prev[pos_n] = pos
      pq << { node: node_n, dist: dist_alt }
    end

  end
  nil
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

# print_map(map)

dist = shortest_path_dijkstra(map, pos_start, dir_start, pos_end)
puts dist
