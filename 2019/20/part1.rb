#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

SYM_WALL = '#'
SYM_OPEN = '.'
SYM_UNDEF = ' '
SYM_PORTAL = /[A-Z]/
SYM_POS_CUR = '@'

PORTAL_START = 'AA'
PORTAL_END = 'ZZ'

NEIGHBOUR_DELTAS = [-1 + 0i, 1 + 0i, 0 - 1i, 0 + 1i]

def print_map(map, pos_cur = nil)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      pos = Complex(x, y)
      print pos_cur == pos ? SYM_POS_CUR : map[pos]
    end
    puts
  end
end

def find_portals(map)
  portals_by_name = Hash.new { |h, k| h[k] = [] } # "xx" -> [Complex, Complex]

  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (xmin..xmax).each do |x|
    (ymin..ymax).each do |y|
      pos = Complex(x, y)
      next unless map[pos].match(SYM_PORTAL)

      ndelta = NEIGHBOUR_DELTAS.select { |d| map[pos + d].match(SYM_PORTAL) }.first
      next unless map[pos + ndelta * 2] == SYM_OPEN

      # Portal names are apparently read from left-to-right like reading.
      name = [pos, pos + ndelta].sort_by(&:rectangular).map { |p| map[p] }.join
      portals_by_name[name] << pos + ndelta * 2
    end
  end

  portals = {} # Complex -> Complex
  portals_by_name.each do |_name, positions|
    portals[positions[0]] = positions[1]
    portals[positions[1]] = positions[0]
  end

  pos_start = portals_by_name[PORTAL_START].first
  pos_end = portals_by_name[PORTAL_END].first

  portals.delete(pos_start)
  portals.delete(pos_end)
  portals.delete(nil)

  [portals, pos_start, pos_end]
end

def visitable_neighbours(map, portals, visited, pos)
  pos_neighbours = NEIGHBOUR_DELTAS.map { |d| pos + d }.select { |p| map[p] == SYM_OPEN }
  pos_neighbours << portals[pos] if portals.include?(pos)
  pos_neighbours.reject { |posn| visited.include?(posn) }
end

def min_steps(map, portals, pos_end, pos, visited = Set.new)
  # puts "min_steps(#{pos}, #{visited})"
  steps_ff = 0
  # Fast-forward simple paths without direction choices to save on recursion depth.
  loop do
    pos_neighbours = visitable_neighbours(map, portals, visited, pos)
    break unless pos_neighbours.length == 1

    pos = pos_neighbours.first
    visited << pos
    steps_ff += 1
  end
  return steps_ff if pos == pos_end

  steps_rest_min = Float::INFINITY
  visitable_neighbours(map, portals, visited, pos).each do |npos|
    steps_rest = 1 + min_steps(map, portals, pos_end, npos, visited + [npos])
    steps_rest_min = [steps_rest_min, steps_rest].min
  end

  steps_ff + steps_rest_min
end

map = Hash.new(SYM_UNDEF) # Complex -> Char
ARGF.each_line.with_index do |line, x|
  line.chomp.each_char.with_index do |char, y|
    next if char == SYM_UNDEF

    pos = Complex(x, y)
    map[pos] = char
  end
end

# print_map(map)

portals, pos_start, pos_end = find_portals(map)
# pp portals, pos_start, pos_end
puts min_steps(map, portals, pos_end, pos_start)
