# frozen_string_literal: true

SYM_ROCKY = '.'
SYM_WET = '='
SYM_NARROW = '|'
SYM_MOUTH = 'M'
SYM_TARGET = 'T'
SYM_PATH = 'P'

TYPE_ROCKY = 0
TYPE_WET = 1
TYPE_NARROW = 2

TYPE2SYM = {
  TYPE_ROCKY => SYM_ROCKY,
  TYPE_WET => SYM_WET,
  TYPE_NARROW => SYM_NARROW
}

POS_MOUTH = 0 + 0i

EROSION_MOD = 20_183
GEO_INDEX_X_MUL = 16_807
GEO_INDEX_Y_MUL = 48_271

def read_input
  depth = ARGF.readline.split[1].to_i
  target = Complex(*ARGF.readline.split[1].split(',').map(&:to_i))
  [depth, target]
end

def geo_index(erosion_levels, target, depth, pos)
  if [POS_MOUTH, target].include?(pos)
    0
  elsif pos.imag.zero?
    pos.real * GEO_INDEX_X_MUL
  elsif pos.real.zero?
    pos.imag * GEO_INDEX_Y_MUL
  else
    erosion_level(erosion_levels, target, depth, pos - 1) * erosion_level(erosion_levels, target, depth, pos - 1i)
  end
end

def erosion_level(erosion_levels, target, depth, pos)
  unless erosion_levels.key?(pos)
    erosion_levels[pos] = (geo_index(erosion_levels, target, depth, pos) + depth) % EROSION_MOD
  end
  erosion_levels[pos]
end

def erosion_levels(target, depth)
  levels = {}

  (POS_MOUTH.imag..target.imag).each do |y|
    (POS_MOUTH.real..target.real).each do |x|
      pos = Complex(x, y)
      levels[pos] = erosion_level(levels, target, depth, pos)
    end
  end
  levels
end

def print_cave(erosion_levels, target, depth, path = nil)
  if path.nil?
    y_max = target.imag
    x_max = target.real
  else
    y_max = path.map(&:imag).max
    x_max = path.map(&:real).max
  end
  (POS_MOUTH.imag..y_max).each do |y|
    (POS_MOUTH.real..x_max).each do |x|
      pos = Complex(x, y)
      if pos == POS_MOUTH
        print SYM_MOUTH
      elsif pos == target
        print SYM_TARGET
      elsif !path.nil? && path.include?(pos)
        print SYM_PATH
      else
        print TYPE2SYM[type(erosion_levels, target, depth, pos)]
      end
    end
    puts
  end
end

def type(erosion_levels, target, depth, pos)
  erosion_level(erosion_levels, target, depth, pos) % 3
end

def types(erosion_levels, target, depth)
  erosion_levels.map { |pos, _lvl| [pos, type(erosion_levels, target, depth, pos)] }.to_h
end
