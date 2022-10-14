# frozen_string_literal: true

SYM_OPEN = '.'
SYM_TREE = '#'
SYM_CHECK_OPEN = 'O'
SYM_CHECK_TREE = 'X'

DEBUG = false

def read_input
  map = Hash.new(SYM_OPEN) # Complex -> sym
  ARGF.each_line.with_index do |line, row|
    line.chomp.each_char.with_index do |sym, col|
      map[Complex(row, col)] = sym
    end
  end
  map
end

def print_travels(map, checks, pos_end)
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  (0..pos_end.real).each do |row|
    (0..pos_end.imag).each do |col|
      pos = Complex(row, col)
      pos_mod = Complex(row % (xmax + 1), col % (ymax + 1))
      if checks.include?(pos)
        print checks[pos]
      else
        print map[pos_mod]
      end
    end
    puts
  end
end

def trees_hit(map, slope)
  pos = 0 + 0i
  xmin, xmax = map.keys.map(&:real).minmax
  ymin, ymax = map.keys.map(&:imag).minmax
  trees_hit = 0
  checks = {} if DEBUG # Complex -> check sym
  until pos.real > xmax
    pos_mod = Complex(pos.real % (xmax + 1), pos.imag % (ymax + 1))
    if map[pos_mod] == SYM_TREE
      checks[pos] = SYM_CHECK_TREE if DEBUG
      trees_hit += 1
    elsif DEBUG
      checks[pos] = SYM_CHECK_OPEN
    end
    pos += slope
  end
  print_travels(map, checks, pos) if DEBUG
  trees_hit
end
