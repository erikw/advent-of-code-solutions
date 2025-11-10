#!/usr/bin/env ruby
# frozen_string_literal: true

# Same as par2_orig.rb but omtimized:
# - Avoid repeated Dijkstra-calls, instead make a reverse calculation from end->start and uritilze the internal state `distances` for looking up the part 2 of the cheat path.
# - Precompute neighbour positions.
# - Only check cheat_positoins that are on the only one path.
# - No need for Dijkstra, there's only one path. Just do BFS.

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

# Precompute neighbor positions for all map positions
def compute_neighbors(map)
  rows = map.size
  cols = map[0].size
  neighbors = {}

  (0...rows).each do |r|
    (0...cols).each do |c|
      neighbors[[r, c]] = NEIGHBOR_DELTAS.map { |dr, dc| [r + dr, c + dc] }
                                         .select { |nr, nc| nr.between?(0, rows - 1) && nc.between?(0, cols - 1) }
    end
  end

  neighbors
end

def neighbor_free_positions(map, neighbors_map, pos)
  neighbors_map[pos].reject { |r, c| map[r][c] == SYM_WALL }
end

# BFS-find all track positions reachable witin CHEAT_MAXLEN_PS steps.
def cheat_positions(neighbors_map, path_set, pos_start)
  poss_cheat = {}
  visited = Set[pos_start]
  queue = [[pos_start, 0]]

  until queue.empty?
    pos, steps = queue.shift
    break if steps >= CHEAT_MAXLEN_PS

    neighbors_map[pos].each do |npos|
      next if visited.include?(npos)

      visited << npos

      # Only save positions that are on the one path.
      poss_cheat[npos] = steps + 1 if path_set.include?(npos)

      # Always queue the neighbor for BFS, even if it’s a wall
      queue << [npos, steps + 1]
    end
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

def shortest_path_bfs(map, neighbors_map, pos_start, pos_end)
  distances = Hash.new(Float::INFINITY)
  distances[pos_start] = 0
  prev = {}

  queue = [pos_start]

  until queue.empty?
    pos = queue.shift
    return [distances, distances[pos], backtrack_path(prev, pos_start, pos_end)] if pos == pos_end

    neighbor_free_positions(map, neighbors_map, pos).each do |npos|
      next if distances[npos] <= distances[pos] + 1

      distances[npos] = distances[pos] + 1
      prev[npos] = pos
      queue << npos
    end
  end

  [nil, nil, nil]
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

# Preompute all neigbour positions.
neighbors_map = compute_neighbors(map)

_, dist, path = shortest_path_bfs(map, neighbors_map, pos_start, pos_end)
path_set = path.to_set

dists_rev = shortest_path_bfs(map, neighbors_map, pos_end, pos_start)[0]

shortest_paths = {}
path.each_with_index do |pos_path, pos_path_index|
  shortest_paths[pos_path] = dist - pos_path_index
end

saved_counts = Hash.new(0)
path.each_with_index do |pos_path, pos_path_index|
  cheat_positions(neighbors_map, path_set, pos_path).each do |pos_cheat, steps_cheat|
    shortest_paths[pos_cheat] = dists_rev[pos_cheat] unless shortest_paths.include?(pos_cheat)
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
