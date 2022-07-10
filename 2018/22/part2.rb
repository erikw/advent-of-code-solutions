#!/usr/bin/env ruby

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
# - Each node defined by positon and tool type when entring it.
# - Adding self-edge to each node for a change of tool.
def dijkstra(erosions, target, depth)
  dist = Hash.new(Float::INFINITY)
  dist[[POS_MOUTH, :tool_torch]] = 0
  prev = {}
  visited = Set.new

  q = MinPriorityQueue.new
  q.push([POS_MOUTH, :tool_torch], dist[[POS_MOUTH, :tool_torch]])
  until q.empty?
    pos, tool = q.pop
    return [dist, prev] if pos == target && tool == :tool_torch

    visited << [pos, tool]
    type_cur = type(erosions, target, depth, pos)

    # Add edge to self with tooling change
    other_tool = (TYPE_TOOLS[type_cur] - [tool]).first
    alt_self = dist[[pos, tool]] + TIME_SWITCH_TOOL
    if !visited.include?([pos, other_tool]) && alt_self < dist[[pos, other_tool]]
      dist[[pos, other_tool]] = alt_self
      prev[[pos, other_tool]] = [pos, tool]
      q.upsert([pos, other_tool], dist[[pos, other_tool]])
    end

    NEIGHBORS_DELTAS.each do |delta|
      pos_n = pos + delta
      next if pos_n.real.negative? || pos_n.imag.negative?

      type_n = type(erosions, target, depth, pos_n)
      alt = dist[[pos, tool]] + TIME_MOVE
      next unless !visited.include?([pos_n, tool]) && TYPE_TOOLS[type_n].include?(tool) && alt < dist[[pos_n, tool]]

      dist[[pos_n, tool]] = alt
      prev[[pos_n, tool]] = [pos, tool]
      q.upsert([pos_n, tool], alt)
    end
  end
  [dist, prev]
end

def construct_path(prev, source, target)
  path = []
  u = target
  t = :tool_torch
  if prev.key?([u, t]) || u == source && t == :tool_torch
    until u.nil?
      path.unshift(u)
      u, t = prev[[u, t]]
    end
  end
  path
end

depth, target = read_input
erosions = erosion_levels(target, depth)
dist, prev = dijkstra(erosions, target, depth)

# path = construct_path(prev, POS_MOUTH, target)
# print_cave(erosions, target, depth, path)

puts dist[[target, :tool_torch]]
