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

bytes = ARGF.each_line(chomp: true).map { |l| l.split(',').map(&:to_i) }

byte_cut = bytes.each_with_index.drop(SIMULATION_BYTES).bsearch do |byte, i|
  corrupted_memory = bytes.first(i + 1).to_set
  shortest_path_dijkstra(corrupted_memory, POS_START, POS_END)[0].nil?
end.first

puts byte_cut.join(',')
