#!/usr/bin/env ruby
# frozen_string_literal: true

require 'lazy_priority_queue'

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

OBJ_YOU = 'YOU'
OBJ_SANTA = 'SAN'

def dijkstra(edges, source, target)
  dist = Hash.new(Float::INFINITY)
  dist[source] = 0
  prev = {}

  q = MinPriorityQueue.new
  q.push(source, dist[[source]])
  until q.empty?
    node = q.pop
    return [dist, prev] if node == target

    edges[node].each do |neighbour|
      alt = dist[node] + 1
      next unless alt < dist[neighbour]

      dist[neighbour] = alt
      prev[neighbour] = node
      q.upsert(neighbour, alt)
    end
  end
  [dist, prev]
end

orbits = Hash.new { |h, k| h[k] = [] } # orbit -> [orbit]
ARGF.each_line do |line|
  orbitee, orbiter = line.chomp.split(')')
  orbits[orbiter] << orbitee
  orbits[orbitee] << orbiter
end

dist, _prev = dijkstra(orbits, OBJ_YOU, OBJ_SANTA)
puts dist[OBJ_SANTA] - 2
