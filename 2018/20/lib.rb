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

class RegexMapParser
  DIERCTIONS = %w[N E S W]
  attr_reader :map

  def initialize(regex)
    @regex = regex
    @map = { [0, 0] => 'X' }
  end

  def parse(pos = 0, coord_start = [0, 0])
    coord = coord_start
    while pos < @regex.length && @regex[pos] != ')'
      case @regex[pos]
      when /[NESW]/
        coord = map_path(@regex[pos], *coord)
      when '('
        pos, coord = parse(pos + 1, coord)
      when '|'
        coord = coord_start
      end
      pos += 1
    end

    [pos, coord]
  end

  private

  def map_path(direction, x, y)
    case direction
    when 'N'
      @map[[x - 1, y]] = SYM_DOOR_HORIZ
      x -= 2
    when 'E'
      @map[[x, y + 1]] = SYM_DOOR_VERTI
      y += 2
    when 'S'
      @map[[x + 1, y]] = SYM_DOOR_HORIZ
      x += 2
    when 'W'
      @map[[x, y - 1]] = SYM_DOOR_VERTI
      y -= 2
    end
    @map[[x, y]] = SYM_ROOM
    [-1, 1].each do |dx|
      [-1, 1].each do |dy|
        @map[[x + dx, y + dy]] = SYM_WALL
      end
    end
    [x, y]
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

# Modified Dijkstra's algorithm from given starting coordinate:
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
