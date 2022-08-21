#!/usr/bin/env ruby
# frozen_string_literal: true

# Algorithm:
# * Same as part1.rb, with addition of for each iteration consider all the keys that can be reach from each robot.

require 'lazy_priority_queue'
require 'set'

SYM_ENTRANCE = '@'
SYM_OPEN = '.'
SYM_WALL = '#'
SYM_KEY = /[a-z]/
SYM_DOOR = /[A-Z]/

NEIGHBORS_DELTAS = [-1 + 0i, 1 + 0i, 0 - 1i, 0 + 1i]

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

def print_map(map, pos_robots, keys_collected = Set.new)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      pos = Complex(x, y)
      if pos_robots.include?(pos)
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

    NEIGHBORS_DELTAS.map do |delta|
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

# Find all keys we can reach from any robot.
def keys_reachable(map, doors, keys_collected, pos_robots)
  pos_robots.each_with_index.map do |pos_robot, robot_idx|
    dist, keypos_found = dijkstra(map, doors, keys_collected, pos_robot)
    keypos_found.map do |pos_key|
      [pos_key, dist[pos_key], robot_idx]
    end
  end.flatten(1)
end

def collect_keys(map, doors, keys, pos_robots, keys_collected = Set.new, cache = {})
  return 0 if keys.length == keys_collected.length

  # print_map(map, pos_robots, keys_collected)
  cache_key = pos_robots.map(&:rectangular).sort.to_s + keys_collected.to_a.sort.to_s
  unless cache.include?(cache_key)
    steps_min = Float::INFINITY
    keys_reachable(map, doors, keys_collected, pos_robots).each do |pos_key, steps_to_key, robot_idx|
      npos_robots = pos_robots.dup
      npos_robots[robot_idx] = pos_key
      nkeys_collected = keys_collected + Set[map[pos_key]]

      steps_rest = collect_keys(map, doors, keys, npos_robots, nkeys_collected, cache)

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

map[pos_entrance] = SYM_WALL
(NEIGHBORS_DELTAS + [-1 - 1i, -1 + 1i, 1 - 1i, 1 + 1i]).each do |delta|
  map[pos_entrance + delta] = SYM_WALL
end
pos_entrances = [-1 - 1i, -1 + 1i, 1 - 1i, 1 + 1i].map do |delta|
  epos = pos_entrance + delta
  map[epos] = SYM_OPEN
  epos
end

# print_map(map, pos_entrances)

puts collect_keys(map, doors, keys, pos_entrances)
