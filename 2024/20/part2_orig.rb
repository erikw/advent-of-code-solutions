#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pqueue'

REAL_INPUT = true

CHEAT_SAVES_PS = if REAL_INPUT
                   100
                 else
                   50
                 end

CHEAT_MAXLEN_PS = 20

SYM_TRACK = '.'
SYM_WALL = '#'
SYM_START = 'S'
SYM_END = 'E'
SYM_PATH = 'O'

NEIGHBOR_DELTAS = [
  [0, -1],
  [1, 0],
  [0, 1],
  [-1, 0]
].freeze

def print_map(map, path)
  path_set = path.to_set
  map.each_with_index do |line, row|
    line.each_char.with_index do |sym, col|
      pos = [row, col]
      if path_set.include?(pos) && ![SYM_START, SYM_END].include?(map[row][col])
        print(SYM_PATH)
      else
        print(sym)
      end
    end
    puts
  end
end

def neighbor_positions(map, pos)
  rows = map.size
  cols = map[0].size
  NEIGHBOR_DELTAS.map { |dr, dc| [pos[0] + dr, pos[1] + dc] }.select do |r, c|
    r.between?(0, rows - 1) && c.between?(0, cols - 1)
  end
end

def neighbor_free_positions(map, pos)
  neighbor_positions(map, pos).reject { |r, c| map[r][c] == SYM_WALL }
end

# BFS-find all track positions reachable witin CHEAT_MAXLEN_PS steps.
def cheat_positions(map, pos)
  poss_cheat = {}
  poss_seen = Set[pos]
  queue = [pos]
  (1..CHEAT_MAXLEN_PS).each do |cheat_steps|
    queue_next = []
    queue.each do |pos_cheat|
      neighbor_positions(map, pos_cheat).each do |pos_cheat_n|
        next if poss_seen.include?(pos_cheat_n)

        poss_seen << pos_cheat_n

        # saving only the first pos_cheat seen, as this will be the shortest one.
        if !poss_cheat.key?(pos_cheat_n) && map[pos_cheat_n[0]][pos_cheat_n[1]] != SYM_WALL
          poss_cheat[pos_cheat_n] = cheat_steps
        end
        queue_next << pos_cheat_n
      end
    end
    queue = queue_next
  end
  poss_cheat.to_a
end

# Iterative backtracking of Dijkstra's algorithm's "prev" output to find the shortests path from self to target.
def backtrack_path(prev, pos_start, pos_end)
  path = []
  current = pos_end

  while current
    path << current
    break if current == pos_start

    current = prev[current]
  end

  path.reverse
end

def shortest_path_dijkstra(map, pos_start, pos_end)
  distances = Hash.new(Float::INFINITY)
  distances[pos_start] = 0
  prev = {}
  pq = PQueue.new([{ node: pos_start, dist: 0 }]) { |a, b| a[:dist] < b[:dist] }

  until pq.empty?
    pos, dist = pq.pop.values_at(:node, :dist)
    next if dist > distances[pos]

    return [distances[pos], backtrack_path(prev, pos_start, pos_end)] if pos == pos_end

    neighbor_free_positions(map, pos).each do |pos_n|
      dist_alt = distances[pos] + 1
      next unless dist_alt < distances[pos_n]

      distances[pos_n] = dist_alt
      prev[pos_n] = pos
      pq << { node: pos_n, dist: dist_alt }
    end

  end
  [nil, nil]
end

pos_start = nil
pos_end = nil
map = ARGF.each_line(chomp: true).with_index.map do |line, row|
  col_start = line.index(SYM_START)
  col_end = line.index(SYM_END)
  pos_start = [row, col_start] unless col_start.nil?
  pos_end = [row, col_end] unless col_end.nil?
  line
end

dist, path = shortest_path_dijkstra(map, pos_start, pos_end)

shortest_paths = {}
path.each_with_index do |pos_path, pos_path_index|
  shortest_paths[pos_path] = dist - pos_path_index
end

saved_counts = Hash.new(0)
path.each_with_index do |pos_path, pos_path_index|
  cheat_positions(map, pos_path).each do |pos_cheat, steps_cheat|
    unless shortest_paths.include?(pos_cheat)
      shortest_paths[pos_cheat] = shortest_path_dijkstra(map, pos_cheat, pos_end)[0]
    end
    dist_cheat_p2 = shortest_paths[pos_cheat]

    dist_cheat = pos_path_index + steps_cheat + dist_cheat_p2
    saved = dist - dist_cheat
    next if saved <= 0

    saved_counts[saved] += 1
  end
end

unless REAL_INPUT
  saved_counts.select { |k, _| k >= CHEAT_SAVES_PS }.sort_by { |k, _| k }.each do |saved, count|
    case count
    when 1
      puts "There is one cheat that saves #{saved} picoseconds."
    else
      puts "There are #{count} cheats that save #{saved} picoseconds."
    end
  end
end

elegible_cheats = saved_counts.select { |saved, _| saved >= CHEAT_SAVES_PS }.map(&:last).sum
puts elegible_cheats
