#!/usr/bin/env ruby
# frozen_string_literal: true

# About 60% faster than the part1_naive.rb, because we don't have to duplicate the map for each recursion.
# Algorithm:
# 1. Shortest-path to every ey we can discover, entering doors that we have keeys though (replace door with open space when enter first time)
# 2. On each path to key available
#    * Backtrack each path. On each path, remove collected keys and doors entered
#    * recurse down and get steps to end, or not all found
# 3. Select shortest of these and move these number of steps and move to this key

require 'lazy_priority_queue'
require 'set'

SYM_ENTRANCE = '@'
SYM_OPEN = '.'
SYM_WALL = '#'
SYM_KEY = /[a-z]/
SYM_DOOR = /[A-Z]/

NEIGHBOUR_DELTAS = [-1 + 0i, 1 + 0i, 0 - 1i, 0 + 1i]

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

def print_map(map, pos_me, keys_collected = Set.new)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      pos = Complex(x, y)
      if pos == pos_me
        print SYM_ENTRANCE
      elsif SYM_KEY.match(map[pos]) && keys_collected.include?(map[pos])
        print SYM_OPEN
      else
        print map[pos]
      end
    end
    puts
  end
  puts
end

# Modified Dijkstra's algorithm:
# - Only adds neighbour positions to queue as they are discovered, to avoid having to BFS all currently available positions before the algoritm.
# - Logic for enterying doors that we have a collected key for.
# - Return all positions of keys encountred.
def dijkstra(map, doors, keys_collected, source)
  dist = Hash.new(Float::INFINITY)
  dist[source] = 0
  keypos_found = Set.new

  q = MinPriorityQueue.new
  q.push(source, dist[source])
  until q.empty?
    pos = q.pop
    if SYM_KEY.match(map[pos]) && !keys_collected.include?(map[pos])
      keypos_found << pos
      next # Don't go beyond this key to keep it simple. Avoid multi-key collection paths.
    end

    NEIGHBOUR_DELTAS.map do |delta|
      npos = pos + delta
      next if map[npos] == SYM_WALL || doors.keys.include?(map[npos]) && !keys_collected.include?(map[npos].downcase)

      alt = dist[pos] + 1
      next unless alt <= dist[npos]

      dist[npos] = alt
      q.upsert(npos, alt)
    end
  end
  [dist, keypos_found]
end

def collect_keys(map, doors, keys, pos_me, keys_collected = Set.new, cache = {})
  return 0 if keys.length == keys_collected.length

  # print_map(map, pos_me, keys_collected)
  cache_key = pos_me.to_s + keys_collected.to_a.sort.to_s
  unless cache.include?(cache_key)

    dist, keypos_found = dijkstra(map, doors, keys_collected, pos_me)
    steps_min = Float::INFINITY
    keypos_found.each do |pos_key|
      steps_to_key = dist[pos_key]
      nkeys_collected = keys_collected + Set[map[pos_key]]

      steps_rest = collect_keys(map, doors, keys, pos_key, nkeys_collected, cache)

      steps_min = [steps_min, steps_to_key + steps_rest].min
    end
    cache[cache_key] = steps_min
  end
  cache[cache_key]
end

map = Hash.new(SYM_WALL)
pos_entrance = nil
doors = {}
keys = {}
ARGF.each_line.with_index do |line, row|
  line.chomp.each_char.with_index do |char, col|
    pos = Complex(row, col)
    map[pos] = char
    case char
    when SYM_ENTRANCE
      pos_entrance = pos
      map[pos] = SYM_OPEN
    when SYM_DOOR
      doors[char] = pos
    when SYM_KEY
      keys[char] = pos
    end
  end
end

# print_map(map, pos_entrance)

puts collect_keys(map, doors, keys, pos_entrance)
