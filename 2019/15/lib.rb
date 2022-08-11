require 'set'
require 'lazy_priority_queue'

require '../09/computer'

STATUS_WALL_HIT = 0
STATUS_MOVED = 1
STATUS_MOVED_OXYSYS = 2

SYM_DROID = 'D'
SYM_WALL = '#'
SYM_OPEN = ' '
SYM_OXYSYS = '*'
# SYM_UNKNOWN = '?'
SYM_UNKNOWN = ' '
SYM_OXYGEN = 'O'

DIR_NORTH = 1
DIR_SOUTH = 2
DIR_WEST = 3
DIR_EAST = 4

DIR2DELTA = {
  DIR_NORTH => -1i,
  DIR_EAST => 1,
  DIR_SOUTH => 1i,
  DIR_WEST => -1
}

DIR_OPPOSITE = {
  DIR_NORTH => DIR_SOUTH,
  DIR_SOUTH => DIR_NORTH,
  DIR_WEST => DIR_EAST,
  DIR_EAST => DIR_WEST
}

POS_START = Complex(0, 0)

class LazyPriorityQueue
  def upsert(element, key)
    change_priority(element, key)
  rescue StandardError
    enqueue(element, key)
  end
end

def print_map(map, droid = nil)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      pos = Complex(x, y)
      print pos == droid ? SYM_DROID : map[pos]
    end
    puts
  end
end

def explore(map, computer, pos)
  (1..4).each do |dir|
    npos = pos + DIR2DELTA[dir]
    next if map.keys.include?(npos)

    computer.stdin << dir
    status = computer.stdout.pop
    case status
    when STATUS_WALL_HIT
      map[npos] = SYM_WALL
    when STATUS_MOVED
      map[npos] = SYM_OPEN
      explore(map, computer, npos)
      computer.stdin << DIR_OPPOSITE[dir]
      computer.stdout.pop
    when STATUS_MOVED_OXYSYS
      map[npos] = SYM_OXYSYS
      computer.stdin << DIR_OPPOSITE[dir]
      computer.stdout.pop
    end
  end
end

def dijkstra(map, source, target)
  dist = Hash.new(Float::INFINITY)
  dist[source] = 0
  prev = {}

  q = MinPriorityQueue.new
  q.push(source, dist[[source]])
  until q.empty?
    pos = q.pop
    return [dist, prev] if pos == target

    (1..4).each do |dir|
      npos = pos + DIR2DELTA[dir]
      next if !map.keys.include?(npos) || map[npos] == SYM_WALL

      alt = dist[pos] + 1
      next unless alt < dist[npos]

      dist[npos] = alt
      prev[npos] = pos
      q.upsert(npos, alt)
    end
  end
  [dist, prev]
end
