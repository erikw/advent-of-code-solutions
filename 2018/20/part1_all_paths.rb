#!/usr/bin/env ruby
# This solution was too memory consuming to generate all paths. The better solution, part1.rb, is to creat the map as we parse instead of storing all paths explicilty.

require 'set'
require 'lazy_priority_queue'

SYM_ROOM = '.'
SYM_WALL = '#'
SYM_DOOR_VERTI = '|'
SYM_DOOR_HORIZ = '-'
SYM_DOORS = [SYM_DOOR_VERTI, SYM_DOOR_HORIZ]

NEIGHBORS_DELTAS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

class RegexParser
  DIERCTIONS = %w[N E S W]

  def initialize(regex)
    @regex = regex
  end

  def parse_paths(pos = 0)
    all_paths = []
    cur_paths = [[]]
    while pos < @regex.length && @regex[pos] != ')'
      case @regex[pos]
      when /[NESW]/
        cur_paths.each { |path| path << @regex[pos] }
      when '('
        group_paths, pos = parse_paths(pos + 1)
        cur_paths_new = []
        group_paths.each do |group_path|
          cur_paths.each do |path|
            cur_paths_new << path + group_path
          end
        end
        cur_paths = cur_paths_new
      when '|'
        all_paths.concat(cur_paths)
        cur_paths = [[]]
      end
      pos += 1
    end
    all_paths.concat(cur_paths)

    puts "Parsed #{all_paths.length} paths at pos #{pos}"
    [all_paths, pos]
  end
end

def map_path(map, path)
  x = 0
  y = 0
  map[[x, y]] = 'X'
  path.each do |direction|
    case direction
    when 'N'
      map[[x - 1, y]] = SYM_DOOR_HORIZ
      x -= 2
    when 'E'
      map[[x, y + 1]] = SYM_DOOR_VERTI
      y += 2
    when 'S'
      map[[x + 1, y]] = SYM_DOOR_HORIZ
      x += 2
    when 'W'
      map[[x, y - 1]] = SYM_DOOR_VERTI
      y -= 2
    end
    map[[x, y]] = SYM_ROOM
    [-1, 1].each do |dx|
      [-1, 1].each do |dy|
        map[[x + dx, y + dy]] = SYM_WALL
      end
    end
  end
end

def print_map(map)
  xmin, xmax = map.keys.map(&:first).minmax
  ymin, ymax = map.keys.map(&:last).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      print map[[x, y]]
    end
    puts
  end
end

# Modified Dijkstra's algorithm from given starting coordinates:
# - Only adds nodes to queue as they are discovered, to avoid having to BFS all currently available positions before the algoritm.
def dijksta(map, start_pos = [0, 0])
  dist = Hash.new(Float::INFINITY)
  dist[start_pos] = 0
  prev = {}
  visited = Set.new

  q = MinPriorityQueue.new
  q.push(start_pos, dist[start_pos])
  until q.empty?
    pos = q.pop
    visited << pos

    NEIGHBORS_DELTAS.map do |dx, dy|
      pos_door = [pos[0] + dx, pos[1] + dy]
      dxr, dyr = [dx, dy].map { |n| n * 2 }
      pos_room = [pos[0] + dxr, pos[1] + dyr]
      alt = dist[pos] + 1
      next unless !visited.include?(pos_room) && SYM_DOORS.include?(map[pos_door]) && alt < dist[pos_room]

      dist[pos_room] = alt
      prev[pos_room] = pos
      q.upsert(pos_room, alt)
    end
  end
  [dist, prev]
end

regex = ARGF.readline.chomp[1...-1]
paths = RegexParser.new(regex).parse_paths[0]
puts "Found paths:\n#{paths.map(&:join).join("\n")}"

map = Hash.new('#')
paths.each do |path|
  map_path(map, path)
end

puts '==== Final map:'
print_map(map)

dist, prev = dijksta(map)
puts '==== Dijksta\'s dist:'
pp dist
puts '==== Dijksta\'s prev:'
pp prev

puts '==== Longest min path:'
puts dist.values.max
