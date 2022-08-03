#!/usr/bin/env ruby
# frozen_string_literal: true
# My original attempt: instead of adding a self-edge, add the cost of changing tool as an edge to the target.
# This solution gives shortest paths that are too short. Still not sure why this happens.

require_relative 'lib'

require 'set'
require 'lazy_priority_queue'

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

TIME_MOVE = 1
TIME_SWITCH_TOOL = 7

TYPE_TOOLS = {
  TYPE_ROCKY => %i[tool_climbing tool_torch],
  TYPE_WET => %i[tool_climbing tool_neither],
  TYPE_NARROW => %i[tool_torch tool_neither]
}

NEIGHBORS_DELTAS = [-1, 1, -1i, 1i]

# Modified Dijkstra's algorithm from given starting coordinate:
# - Only adds nodes to queue as they are discovered, to avoid having to BFS all currently available positions before the algoritm.
# - Quit early when finding target, as the cave could be infinite
def dijkstra(erosions, target, depth)
  dist = Hash.new(Float::INFINITY)
  dist[POS_MOUTH] = 0
  prev = {}
  visited = Set.new

  q = MinPriorityQueue.new
  q.push([POS_MOUTH, :tool_torch], dist[POS_MOUTH])
  until q.empty?
    pos, tool = q.pop
    return [dist, prev] if pos == target

    visited << [pos, tool]
    type_cur = type(erosions, target, depth, pos)

    NEIGHBORS_DELTAS.map do |delta|
      pos_n = pos + delta
      next if pos_n.real.negative? || pos_n.imag.negative?

      type_n = type(erosions, target, depth, pos_n)
      compat_tools = TYPE_TOOLS[type_cur].intersection(TYPE_TOOLS[type_n])
      compat_tools.each do |compat_tool|
        alt = dist[pos] + TIME_MOVE
        alt += TIME_SWITCH_TOOL if compat_tool != tool
        alt += TIME_SWITCH_TOOL if pos_n == target && compat_tool == :tool_climbing
        next unless !visited.include?([pos_n, compat_tool]) && alt < dist[pos_n]

        dist[pos_n] = alt
        prev[pos_n] = pos
        q.upsert([pos_n, compat_tool], alt)
      end
    end
  end
  [dist, prev]
end

def construct_path(prev, source, target)
  path = []
  u = target
  if prev.key?(u) || u == source
    until u.nil?
      path.unshift(u)
      u = prev[u]
    end
  end
  path
end

depth, target = read_input
erosions = erosion_levels(target, depth)
dist, prev = dijkstra(erosions, target, depth)

# path = construct_path(prev, POS_MOUTH, target)
# print_cave(erosions, target, depth, path)

puts dist[target]
