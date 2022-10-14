# frozen_string_literal: true

require 'set'

DIRECTIONS_DELTA = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def distance_bfs(maze, row_from, col_from, row_to, col_to)
  visited = Set.new
  que = Thread::Queue.new
  que << [0, row_from, col_from]

  until que.empty?
    dist, row, col = que.pop
    next if visited.include?([row, col]) || maze[row][col] == '#'

    return dist if row == row_to && col == col_to

    visited << [row, col]
    DIRECTIONS_DELTA.each do |dr, dc|
      que << [1 + dist, row + dr, col + dc]
    end
  end

  Float::INFINITY
end

def tsp(distances, start, return_home: true)
  min_dist = Float::INFINITY
  distances.keys.reject { |k| k == start }.permutation do |ordering|
    ordering.unshift(start)
    ordering << start if return_home
    dist = ordering.each_cons(2).sum { |from, to| distances[from][to] }
    min_dist = [min_dist, dist].min
  end
  min_dist
end

def find_distances(maze, locations)
  distances = Hash.new { |h, k| h[k] = {} }
  locations.keys.combination(2) do |digit1, digit2|
    loc1 = locations[digit1]
    loc2 = locations[digit2]

    dist = distance_bfs(maze, loc1[0], loc1[1], loc2[0], loc2[1])
    distances[digit1][digit2] = dist
    distances[digit2][digit1] = dist
  end
  distances
end

def load_input
  locations = {}
  maze = ARGF.each_line.with_index.map do |line, row|
    line.chomp.each_char.with_index.map do |c, col|
      locations[c] = [row, col] if c.match(/\d/)
      c
    end
  end
  [maze, locations]
end
