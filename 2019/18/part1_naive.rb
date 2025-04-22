#!/usr/bin/env ruby
# frozen_string_literal: true

# Algorithm
# 1. Shortest-path to every ey we can discover, entering doors that we have keeys though (replace door with open space when enter first time)
# 2. On each path to key available
#    * Backtrack each path. On each path, remove collected keys and doors entered
#    * recurse down and get steps to end, or notall found
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

def print_map(map, pos_me)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      pos = Complex(x, y)
      print pos == pos_me ? SYM_ENTRANCE : map[pos]
    end
    puts
  end
  puts
end

# Modified Dijkstra's algorithm:
# - Only adds neighbour positions to queue as they are discovered, to avoid having to BFS all currently available positions before the algoritm.
# - Logic for enterying doors that we have a collected key for.
# - Return all positions of keys encountred.
def dijkstra(map, doors, _keys, keys_collected, source)
  dist = Hash.new(Float::INFINITY)
  dist[source] = 0
  prev = {}
  keypos_found = Set.new

  q = MinPriorityQueue.new
  q.push(source, dist[source])
  until q.empty?
    pos = q.pop
    if SYM_KEY.match(map[pos])
      keypos_found << pos
      next # Don't go beyond this key to keep it simple. Avoid multi-key collection paths.
    end

    NEIGHBOUR_DELTAS.map do |delta|
      npos = pos + delta
      next if map[npos] == SYM_WALL || doors.keys.include?(map[npos]) && !keys_collected.include?(map[npos].downcase)

      alt = dist[pos] + 1
      next unless alt <= dist[npos]

      dist[npos] = alt
      prev[npos] = pos
      q.upsert(npos, alt)
    end
  end
  [dist, prev, keypos_found]
end

# Back-tracking of Dijkstra's algorithm's "prev" output to find the shortests path from source to target.
def backtrack_path(prev, source, target)
  path = []
  pos = target
  if !prev[pos].nil? || pos == source
    until pos.nil?
      path.prepend(pos)
      pos = prev[pos]
    end
  end
  path
end

# This is removed in part1.rb as it's only purpose was to clear out doors after
# entering them, but actually we can just leave the doors in the map and enter
# them later. No need to backtrack the paths all the time!
def clear_doors_path(map, path, _doors, _keys, keys_collected)
  path.each do |pos|
    next unless SYM_DOOR.match(map[pos])

    unless keys_collected.include?(map[pos].downcase)
      require 'byebug'; byebug # rubocop:disable Style/Semicolon
    end
    map[pos] = SYM_OPEN
  end
end

def collect_keys(map, doors, keys, pos_me, keys_collected = [], cache = {})
  # puts "collect_keys(#{pos_me}, #{keys_collected.inspect})"
  # print_map(map, pos_me)

  return 0 if keys.length == keys_collected.length

  cache_key = pos_me.to_s + keys_collected.sort.to_s
  unless cache.include?(cache_key)

    dist, prev, keypos_found = dijkstra(map, doors, keys, keys_collected, pos_me)
    steps_min = Float::INFINITY
    # require 'byebug'; byebug
    keypos_found.each do |pos_key|
      path = backtrack_path(prev, pos_me, pos_key)
      # puts "From #{pos_me} to #{pos_key}: #{path.inspect}"

      steps_to_key = path.length - 1
      nmap = Marshal.load(Marshal.dump(map))
      nkeys_collected = Marshal.load(Marshal.dump(keys_collected))
      nkeys_collected << map[path.last]
      nmap[path.last] = SYM_OPEN

      clear_doors_path(nmap, path, doors, keys, nkeys_collected)
      steps_rest = collect_keys(nmap, doors, keys, path.last, nkeys_collected, cache)

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

steps = collect_keys(map, doors, keys, pos_entrance)
puts steps
