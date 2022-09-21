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

PTYPE_INNER = :inner
PTYPE_OUTER = :outer

# Notes from input2.2: not only can you enter the same portal twice, but also coming from the same portal. Thus saving visited portals is not a way to detect infinite recursion.
MAX_LEVELS = 25 # Empirically found and not by chance coinciding with christmas. Set to 15 for input2.2.

NEIGHBOURS_DELTAS = [-1 + 0i, 1 + 0i, 0 - 1i, 0 + 1i]

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

      ndelta = NEIGHBOURS_DELTAS.select { |d| map[pos + d].match(SYM_PORTAL) }.first
      next unless map[pos + ndelta * 2] == SYM_OPEN

      # Portal names are apparently read from left-to-right like reading.
      name = [pos, pos + ndelta].sort_by(&:rectangular).map { |p| map[p] }.join
      ptype = [xmin, xmax].include?(pos.real) || [ymin, ymax].include?(pos.imag) ? PTYPE_OUTER : PTYPE_INNER
      portals_by_name[name] << [pos + ndelta * 2, ptype]
    end
  end

  portals = {} # Complex -> [Complex, PTYPE]
  portals_by_name.each do |_name, positions|
    next unless positions.length > 1

    portals[positions[0][0]] = [positions[1][0], positions[0][1]]
    portals[positions[1][0]] = [positions[0][0], positions[1][1]]
  end

  pos_start = portals_by_name[PORTAL_START].first[0]
  pos_end = portals_by_name[PORTAL_END].first[0]

  [portals, pos_start, pos_end]
end

# All visitable neighbours and what level, as neighbours via portals are considerd a neighbour as well.
def visitable_neighbours(map, portals, visited, pos, level)
  pos_neighbours = NEIGHBOURS_DELTAS.map { |d| [pos + d, level] }.select { |p, _l, _pn| map[p] == SYM_OPEN }

  if portals.include?(pos)
    port_pos, ptype = portals[pos]
    unless level == 0 && ptype == PTYPE_OUTER
      port_level = level + (ptype == PTYPE_INNER ? 1 : -1)
      pos_neighbours << [port_pos, port_level]
    end
  end

  pos_neighbours.reject { |npos, nlevel| visited.include?([npos, nlevel]) }
end

def min_steps(map, portals, pos_end, pos, visited = Set.new, level = 0)
  return Float::INFINITY unless level.between?(0, MAX_LEVELS)

  steps_ff = 0
  # Fast-forward simple paths without direction choices to save on recursion depth.
  loop do
    pos_neighbours = visitable_neighbours(map, portals, visited, pos, level)
    break unless pos_neighbours.length == 1

    npos, nlevel = pos_neighbours.first
    pos = npos
    level = nlevel

    visited << [pos, level]
    steps_ff += 1
  end
  return steps_ff if pos == pos_end && level == 0

  steps_rest_min = Float::INFINITY
  visitable_neighbours(map, portals, visited, pos, level).each do |npos, nlevel|
    steps_rest = 1 + min_steps(map, portals, pos_end, npos, visited + [[npos, nlevel]], nlevel)
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

portals, pos_start, pos_end = find_portals(map)
puts min_steps(map, portals, pos_end, pos_start, Set[[pos_start, 0]])
