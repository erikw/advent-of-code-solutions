#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

# SIMULATION_BYTES = 12
# MEM_DIM = 6

SIMULATION_BYTES = 1024
MEM_DIM = 70

SYM_SAFE = '.'
SYM_CORRUPTED = '#'
SYM_PATH = 'O'

POS_START = [0, 0].freeze
POS_END = [MEM_DIM, MEM_DIM].freeze

NEIGHBOR_DELTAS = [
  [0, -1],
  [1, 0],
  [0, 1],
  [-1, 0]
].freeze

def print_memory(corrupted_memory, path = [])
  path_set = Set.new(path)
  (MEM_DIM + 1).times do |y|
    (MEM_DIM + 1).times do |x|
      pos = [x, y]
      if corrupted_memory.include?(pos)
        print(SYM_CORRUPTED)
      elsif path_set.include?(pos)
        print(SYM_PATH)
      else
        print(SYM_SAFE)
      end
    end
    puts
  end
end

def neighbor_free_positions(corrupted_memory, pos)
  NEIGHBOR_DELTAS.map { |dx, dy| [pos[0] + dx, pos[1] + dy] }.select do |x, y|
    !corrupted_memory.include?([x, y]) && x.between?(0, MEM_DIM) && y.between?(0, MEM_DIM)
  end
end

def shortest_path_dijkstra(corrupted_memory, pos_start, pos_end)
  distances = Hash.new(Float::INFINITY)
  distances[pos_start] = 0
  prev = {}
  pq = PQueue.new([{ node: pos_start, dist: 0 }]) { |a, b| a[:dist] < b[:dist] }

  until pq.empty?
    pos, dist = pq.pop.values_at(:node, :dist)
    next if dist > distances[pos]

    return [distances[pos], prev] if pos == pos_end

    neighbor_free_positions(corrupted_memory, pos).each do |pos_n|
      dist_alt = distances[pos] + 1
      next unless dist_alt < distances[pos_n]

      distances[pos_n] = dist_alt
      prev[pos_n] = pos
      pq << { node: pos_n, dist: dist_alt }
    end

  end
  [nil, nil]
end

# Recursive back-tracking of Dijkstra's algorithm's "prev" output to find the shortests path from self to target.
def backtrack_path(prev, pos_start, pos)
  return [pos] if pos == pos_start
  return [] if prev[pos].nil?

  backtrack_path(prev, pos_start, prev[pos]) + [pos]
end

corrupted_memory = ARGF.each_line(chomp: true).first(SIMULATION_BYTES).map { |l| l.split(',').map(&:to_i) }.to_set

dist, prev = shortest_path_dijkstra(corrupted_memory, POS_START, POS_END)

# path = backtrack_path(prev, POS_START, POS_END)
# print_memory(corrupted_memory, path)

puts dist
